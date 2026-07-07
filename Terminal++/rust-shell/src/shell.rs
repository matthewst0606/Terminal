use std::sync::{Mutex, OnceLock};
use std::thread;

use crate::command::builtin::Builtin;
use crate::command::input::Input;
use crate::command::output::Output;
use crate::record_history::RecordHistory;
use crate::terminal::manager::TerminalManager;
use crate::terminal::session::TerminalSession;

static SHELL: OnceLock<Mutex<Shell>> = OnceLock::new();

pub(crate) struct Shell {
    current_session: usize,
    manager: Mutex<TerminalManager>,
}

impl Shell {
    // initialize a new shell
    pub(crate) fn new() -> Self {
        Self { 
            current_session: 0, 
            manager: Mutex::new(TerminalManager::new()) 
        }
    }

    // uses the manager to perform an action,
    // e.g. spawning a background command
    pub(crate) fn with_manager<T>(
        &self, 
        action: impl FnOnce(&mut TerminalManager) -> T
    ) -> T {
        let mut manager = self.manager
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner());

        action(&mut manager)
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
        self.with_manager(|manager| manager.sessions[self.current_session].history.clone())
    }




    // executes the command
    fn execute(&self, command: &str, history: RecordHistory) -> Output {
        let command = command.trim();
        let input = Input::parse(command);

        if matches!(input, Input::Empty) {
            return Output::Text(self.finished_jobs(String::new()));
        }

        if history.record() {
            self.record_command(command);
        }

        let output = self.run_input(input);
        match output {
            Output::Text(text) => Output::Text(self.finished_jobs(text)),

            output => output,
        }
    }

    fn finished_jobs(&self, mut output: String) -> String {
        let finished_output = self.with_manager(|manager| {
            TerminalSession::output(&mut manager.sessions[self.current_session])
        });

        push_newline(&mut output, &finished_output);
        output
    }

    fn record_command(&self, command: &str) {
        self.with_manager(|manager| {
            let session = &mut manager.sessions[self.current_session];
            session.current_dir = Builtin::pwd();
            session.history.push(command.to_string());
        });
    }

    fn run_builtin(&self, builtin: Builtin) -> Output {
        match builtin {
            Builtin::Exit => Output::Exit,
            Builtin::Clear => Output::Clear,
            Builtin::ClearLine => Output::ClearLine,
            Builtin::Pwd => Output::Text(Builtin::pwd()),
            Builtin::Ls => Output::Text(Builtin::ls()),
            Builtin::Cd(path) => Output::Text(Builtin::cd(path.as_deref())),
            Builtin::Spawn(command) => Output::Text(self.spawn_background(command)),
            Builtin::Session => Output::Text(self.sessions()),
            Builtin::Jobs => Output::Text(self.jobs()),
        }
    }

    fn run_input(&self, input: Input) -> Output {
        match input {
            Input::Empty => Output::Text(String::new()),
            Input::Builtin(builtin) => self.run_builtin(builtin),
            Input::External(command) => Output::Text(command.run()),
        }
    }

    fn spawn_background(&self, command: String) -> String {
        let handle = thread::spawn(move || Self::new().spawn(&command).string());

        self.with_manager(|manager| {
            manager.sessions[self.current_session].jobs.push(handle);
        });

        String::new()
    }

    fn sessions(&self) -> String {
        self.with_manager(|manager| {
            let session = &manager.sessions[self.current_session];
            format!(
                "current session: {}\ncurrent dir: {}\nhistory item(s): {}\nbackground job(s): {}",
                session.id,
                session.current_dir,
                session.history.len(),
                session.jobs.len()
            )
        })
    }

    fn jobs(&self) -> String {
        self.with_manager(|manager| {
            let session = &mut manager.sessions[self.current_session];
            let finished_output = TerminalSession::output(session);
            let mut output = format!("{} background job(s)", session.jobs.len());

            push_newline(&mut output, &finished_output);
            output
        })
    }
}

pub(crate) fn with_shell<T>(action: impl FnOnce(&Shell) -> T) -> T {
    let shell = SHELL.get_or_init(|| Mutex::new(Shell::new()));
    let shell = shell
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());

    action(&shell)
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
