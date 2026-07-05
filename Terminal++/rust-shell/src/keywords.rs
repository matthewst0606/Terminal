use crate::terminal_manager::{TerminalManager, create_manager};
use crate::terminal_output::CmdOut;
use crate::terminal_session::{TerminalSession, create_session, finished_jobs_output};
use std::sync::{Mutex, OnceLock};
use std::thread;

use crate::run_bg_command;
const CURRENT_SESSION: usize = 0;



// formats "ls" in columns unless additional
// arguments are provided
pub fn ls(process: &mut std::process::Command, command: &str, args: &[String]) {
    if command == "ls" && args.is_empty() {
        process.arg("-C");
    } else {
        process.args(args.iter().map(String::as_str));
    }
}

// prints the current session id, directory, history, and jobs
pub fn sessions(manager: &TerminalManager, current: usize) -> String {
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
pub fn jobs(session: &mut TerminalSession) -> String {
    let finished_output = finished_jobs_output(session);
    let mut output = format!("{} background job(s)", session.jobs.len());

    if !finished_output.is_empty() {
        output.push('\n');
        output.push_str(&finished_output);
    }
    output
}

// gets the current directory
pub fn pwd() -> String {
    match std::env::current_dir() {
        Ok(path) => path.display().to_string(),
        Err(message) => CmdOut::Error {
            command: "pwd".to_string(),
            message: message.to_string(),
        }
        .into_string(),
    }
}

// changes the current directory
pub fn cd(path: Option<&str>) -> String {
    let Some(path) = path else {
        return CmdOut::Error {
            command: "cd".to_string(),
            message: "missing path".to_string(),
        }
        .into_string();
    };

    match std::env::set_current_dir(path) {
        Ok(()) => String::new(),
        Err(message) => CmdOut::Error {
            command: "cd".to_string(),
            message: message.to_string(),
        }
        .into_string(),
    }
}

pub fn manager() -> &'static Mutex<TerminalManager> {
    static MANAGER: OnceLock<Mutex<TerminalManager>> = OnceLock::new();

    MANAGER.get_or_init(|| {
        let mut manager = create_manager();
        manager.sessions.push(create_session());
        Mutex::new(manager)
    })
}

pub fn with_manager<T>(action: impl FnOnce(&mut TerminalManager) -> T) -> T {
    let mut manager = manager()
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());

    action(&mut manager)
}

pub fn spawn_bg_command(command: String) -> String {
    let handle = thread::spawn(move || run_bg_command(&command).into_string());

    with_manager(|manager| {
        manager.sessions[CURRENT_SESSION].jobs.push(handle);
    });

    String::new()
}

pub fn record_command(command: &str) {
    with_manager(|manager| {
        let session = &mut manager.sessions[CURRENT_SESSION];
        session.current_dir = pwd();
        session.history.push(command.to_string());
    });
}

pub fn append_finished_jobs(mut output: String) -> String {
    let finished_output = with_manager(|manager| 
        finished_jobs_output(&mut manager.sessions[CURRENT_SESSION])
    );

    if !finished_output.is_empty() {
        if !output.is_empty() && !output.ends_with('\n') {
            output.push('\n');
        }
        output.push_str(&finished_output);
    }
    output
}

