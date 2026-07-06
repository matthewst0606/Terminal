use crate::command::output::Output;
use crate::shell::Shell;
use crate::terminal::manager::{TerminalManager, with_manager};
use crate::terminal::session::TerminalSession;
use std::thread;

const CURRENT_SESSION: usize = 0;

pub(crate) enum Builtin {
    Exit,
    Clear,
    ClearLine,
    Session,
    Jobs,
    Pwd,
    Cd(Option<String>),
    Spawn(String),
}

impl Builtin {
    pub(crate) fn parse(command: &str, args: &[String]) -> Option<Builtin> {
        match command {
            "exit" | "quit" => Some(Builtin::Exit),
            "pwd" => Some(Builtin::Pwd),
            "cd" => Some(Builtin::Cd(args.first().cloned())),

            "clear" => Some(Builtin::Clear),
            "clearline" => Some(Builtin::ClearLine),

            "spawn" => Some(Builtin::Spawn(args.join(" "))),
            "sessions" => Some(Builtin::Session),
            "jobs" => Some(Builtin::Jobs),
            _ => None,
        }
    }

    pub(crate) fn run(builtin: Builtin) -> Output {
        match builtin {
            Builtin::Exit => Output::Exit,
            Builtin::Clear => Output::Clear,
            Builtin::ClearLine => Output::ClearLine,
            Builtin::Pwd => Output::Text(Builtin::pwd()),

            Builtin::Cd(path) => Output::Text(Builtin::cd(path.as_deref())),
            Builtin::Spawn(command) => Output::Text(Builtin::spawn(command)),
            Builtin::Session => Output::Text(with_manager(|manager| {
                Builtin::sessions(manager, CURRENT_SESSION)
            })),
            Builtin::Jobs => Output::Text(with_manager(|manager| {
                Builtin::jobs(&mut manager.sessions[CURRENT_SESSION])
            })),
        }
    }

    // formats "ls" in columns unless additional
    // arguments are provided
    pub(crate) fn ls(process: &mut std::process::Command, command: &str, args: &[String]) {
        match (command, args.is_empty()) {
            ("ls", true) => process.arg("-C"),
            _ => process.args(args.iter().map(String::as_str)),
        };
    }

    // gets the current directory
    pub(crate) fn pwd() -> String {
        match std::env::current_dir() {
            Ok(path) => path.display().to_string(),
            Err(message) => Output::Error {
                command: "pwd".to_string(),
                message: message.to_string(),
            }
            .string(),
        }
    }

    // changes the current directory
    pub(crate) fn cd(path: Option<&str>) -> String {
        let Some(path) = path else {
            return Output::Error {
                command: "cd".to_string(),
                message: "missing path".to_string(),
            }
            .string();
        };

        match std::env::set_current_dir(path) {
            Ok(()) => String::new(),
            Err(message) => Output::Error {
                command: "cd".to_string(),
                message: message.to_string(),
            }
            .string(),
        }
    }

    // creates a background command
    pub(crate) fn spawn(command: String) -> String {
        let handle = thread::spawn(move || Shell::new().spawn(&command).string());

        with_manager(|manager| {
            manager.sessions[CURRENT_SESSION].jobs.push(handle);
        });

        String::new()
    }

    // prints the current session id, directory, history, and jobs
    pub(crate) fn sessions(manager: &TerminalManager, current: usize) -> String {
        let session = &manager.sessions[current];
        format!(
            "current session: {}\ncurrent dir: {}\nhistory item(s): {}\nbackground job(s): {}",
            session.id,
            session.current_dir,
            session.history.len(),
            session.jobs.len()
        )
    }

    // prints the number of running jobs in a session, and provides
    // the details for those jobs
    pub(crate) fn jobs(session: &mut TerminalSession) -> String {
        let finished_output = TerminalSession::output(session);
        let mut output = format!("{} background job(s)", session.jobs.len());

        if !finished_output.is_empty() {
            output.push('\n');
            output.push_str(&finished_output);
        }
        output
    }
}
