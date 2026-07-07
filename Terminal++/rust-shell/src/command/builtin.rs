use crate::command::{output::Output};
use std::process::Command;
pub(crate) enum Builtin {
    Exit,
    Clear,
    ClearLine,
    Session,
    Jobs,
    Pwd,
    Ls,
    Cd(Option<String>),
    Spawn(String),
}

impl Builtin {
    pub(crate) fn parse(command: &str, args: &[String]) -> Option<Builtin> {
        match command {
            "exit" | "quit" => Some(Self::Exit),
            "dir" | "pwd" => Some(Self::Pwd),
            "cd" => Some(Self::Cd(args.first().cloned())),
            "ls" | "list" => Some(Self::Ls),
            "clear" => Some(Self::Clear),
            "clearline" => Some(Self::ClearLine),

            "spawn" => Some(Self::Spawn(args.join(" "))),
            "sessions" | "session" => Some(Self::Session),
            "jobs" | "job" => Some(Self::Jobs),
            _ => None,
        }
    }

    // formats "ls" in columns unless additional
    // arguments are provided
    pub(crate) fn ls() -> String {
        Command::new("ls")
            .arg("-C")
            .output()
            .map(|output| 
                String::from_utf8_lossy(&output.stdout).to_string()
            )
            .unwrap_or_else(|message| message.to_string())
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
}
