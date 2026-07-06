// use std::sync::{Mutex, OnceLock};

use crate::command::builtin::Builtin;
use crate::command::input::Input;
use crate::command::output::Output;
use crate::terminal::manager::{with_manager};
use crate::terminal::session::TerminalSession;
use crate::record_history::RecordHistory;

// static SHELL: OnceLock<Mutex<Shell>> = OnceLock::new();

pub(crate) struct Shell {
    current_session: usize,
    // manager: Mutex<TerminalManager>
}


impl Shell {
    // initialize a new shell
    pub(crate) fn new() -> Shell {
        Shell { 
            current_session: 0,
        }
    }

    // runs a regular command.
    // (history is recorded with regular commands)
    pub(crate) fn run(&self, command: String) -> String {
        self.execute(&command, RecordHistory::Yes).string()
    }

    // spawns a background command.
    // (history is not recorded with background commands)
    pub(crate) fn spawn(&self, command: &str) -> Output {
        self.execute(command, RecordHistory::No)
    }


    pub(crate) fn history(&self, _command: String) -> Vec<String> {
        with_manager(|manager| { manager
            .sessions[self.current_session]
            .history
            .clone()
        })
    }

    // executes the command
    fn execute(&self, command: &str, history: RecordHistory) -> Output {
        let command = command.trim();
        let input = Input::parse(command);

        if matches!(input, Input::Empty) {
            return Output::Text(
                self.finished_jobs(String::new())
            );
        }

        if history.record() {
            self.record_command(command);
        }


        let output = run_input(input);
        match output {
            Output::Text(text) => Output::Text(
                self.finished_jobs(text)
            ),

            output => output,
        }
    }

    fn finished_jobs(&self, mut output: String) -> String {
        let finished_output = with_manager(|manager| {
            TerminalSession::output(
                &mut manager.sessions[self.current_session]
            )
        });


        push_newline(&mut output, &finished_output);
        output
    }

    fn record_command(&self, command: &str) {
        with_manager(|manager| {
            let session = &mut manager.sessions[self.current_session];
            session.current_dir = Builtin::pwd();
            session.history.push(command.to_string());
        });
    }


    
}



fn push_newline(output: &mut String, text: &str) {
    if text.is_empty() {
        return;
    }
    if !output.is_empty() && !output.ends_with('\n') {
        output.push('\n');
    }

    output.push_str(text);
}

// takes in parsed input and executes it
fn run_input(input: Input) -> Output {
    match input {
        Input::Empty => Output::Text(String::new()),
        Input::Builtin(builtin) => Builtin::run(builtin),
        Input::External(command) => Output::Text(command.run()),
    }
}


