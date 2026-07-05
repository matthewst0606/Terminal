mod terminal_manager;
mod terminal_session;

use std::sync::{Mutex, OnceLock};
use std::thread;
use terminal_manager::{create_manager, TerminalManager};
use terminal_session::{create_session, finished_jobs_output, TerminalSession};

const CURRENT_SESSION: usize = 0;

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        fn terminal_execute(command: String) -> String;
        fn terminal_history(command: String) -> Vec<String>;
    }
}

// --------- public ---------
pub fn terminal_execute(command: String) -> String {
    run_command(&command)
}

pub fn terminal_history(command: String) -> Vec<String> {
    let mut history: Vec<String> = Vec::new();
    history.push(command);
    history
}




// --------- private ---------
fn run_command(command: &str) -> String {
    let command = command.trim();

    if let Some(background_command) = command.strip_prefix("spawn ") {
        return spawn_background_command(background_command.to_string());
    }

    let parsed_tokens = parse_command(command);

    if parsed_tokens.is_empty() {
        return String::new();
    }


    let path = parsed_tokens.get(1).map(String::as_str);

    match parsed_tokens[0].as_str() {
        "exit" | "quit" => exit(),
        "clear" => clear(),
        "clearline" => clear_line(),
        "sessions" => with_manager(|manager| sessions(manager, CURRENT_SESSION)),
        "jobs" => with_manager(|manager| jobs(&mut manager.sessions[CURRENT_SESSION])),
        "pwd" => current_directory(),
        "cd" => change_directory(path),
        _ => {
            let output = run_external_command(&parsed_tokens);
            record_command(command);
            append_finished_jobs(output)
        }
    }
}

// combines arguments that are wrapped in quotes
fn parse_command(command: &str) -> Vec<String> {
    let mut tokens = Vec::new();
    let mut current = String::new();
    let mut in_quotes = false;

    for c in command.chars() {
        match c {
            '"' => in_quotes = !in_quotes,
            ' ' | '\t' if !in_quotes => {
                if !current.is_empty() {
                    tokens.push(current);
                    current = String::new();
                }
            }
            _ => current.push(c),
        }
    }
    if !current.is_empty() {
        tokens.push(current);
    }


    tokens
}


// --------- helpers ---------
fn error(command: &str, message: &str) -> String {
    format!("__ERROR__|{}|{}", command, message)
}

fn exit() -> String {
    "__EXIT__".to_string()
}

// clears the terminal
fn clear() -> String {
    "__CLEAR__".to_string()
}

// clears the previous line
fn clear_line() -> String {
    "__CLEARLINE__".to_string()
}

fn manager() -> &'static Mutex<TerminalManager> {
    static MANAGER: OnceLock<Mutex<TerminalManager>> = OnceLock::new();

    MANAGER.get_or_init(|| {
        let mut manager = create_manager();
        manager.sessions.push(create_session());
        Mutex::new(manager)
    })
}

fn with_manager<T>(action: impl FnOnce(&mut TerminalManager) -> T) -> T {
    let mut manager = manager()
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());

    action(&mut manager)
}

// gets the current directory
pub fn current_directory() -> String {
    match std::env::current_dir() {
        Ok(path) => path.display().to_string(),
        Err(message) => error("pwd", &format!("failed: {}", message)),
    }
}


// changes the current directory
fn change_directory(path: Option<&str>) -> String {
    let Some(path) = path else {
        return error("cd", "missing path");
    };

    match std::env::set_current_dir(path) {
        Ok(()) => String::new(),
        Err(message) => error("cd", &format!("failed: {}", message)),
    }
}

fn spawn_background_command(command: String) -> String {
    let handle = thread::spawn(move || run_command(&command));

    with_manager(|manager| {
        manager.sessions[CURRENT_SESSION].jobs.push(handle);
    });

    String::new()
}

fn record_command(command: &str) {
    with_manager(|manager| {
        let session = &mut manager.sessions[CURRENT_SESSION];
        session.current_dir = current_directory();
        session.history.push(command.to_string());
    });
}

fn append_finished_jobs(mut output: String) -> String {
    let finished_output = with_manager(|manager| {
        finished_jobs_output(&mut manager.sessions[CURRENT_SESSION])
    });

    if !finished_output.is_empty() {
        output.push_str(&finished_output);
    }

    output
}

fn ls(
    process: &mut std::process::Command, 
    command: &str, 
    args: &[String]
) {
    if command == "ls" && args.is_empty() {
        process.arg("-C");
    } else {
        process.args(
            args.iter().map(String::as_str)
        );
    }
}

fn sessions(manager: &TerminalManager, current: usize) -> String {
    format!("current session: {:?}", manager.sessions[current])
}

fn jobs(session: &mut TerminalSession) -> String {
    format!(
        "{} background job(s)\n{:?}",
        session.jobs.len(),
        session.jobs
    )
}



fn run_external_command(tokens: &[String]) -> String {
    let command = tokens[0].as_str();
    let args = &tokens[1..];
    let mut process = std::process::Command::new(command);
    ls(&mut process, command, args);

    match process.output() {
        Ok(output) => {
            let mut text = String::new();
            text.push_str(&String::from_utf8_lossy(&output.stdout));
            text.push_str(&String::from_utf8_lossy(&output.stderr));


            if text.trim().is_empty() && !output.status.success() {
                return error(command, &format!("exited with {}", output.status));
            } else { 
                text 
            }
        }
        Err(message) => error(command, &format!("{}", message)),
    }
}
