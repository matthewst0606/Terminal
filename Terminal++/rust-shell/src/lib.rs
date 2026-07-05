mod keywords;
mod terminal_input;
mod terminal_manager;
mod terminal_output;
mod terminal_session;

use terminal_input::{CmdIn, parse_command};
use terminal_output::CmdOut;
use crate::keywords::{
    append_finished_jobs, cd, pwd, 
    jobs, ls, record_command, sessions,
    spawn_bg_command, with_manager,
};

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
    run_command(&command).into_string()
}

pub fn terminal_history(_command: String) -> Vec<String> {
    with_manager(|manager| manager.sessions[CURRENT_SESSION].history.clone())
}




// --------- private ---------

// history is recorded with regular commands  
fn run_command(command: &str) -> CmdOut {
    exec_command(command, true)
}

// history is not recorded with background commands  
pub(crate) fn run_bg_command(command: &str) -> CmdOut {
    exec_command(command, false)
}

// executes the command
fn exec_command(command: &str, should_record: bool) -> CmdOut {
    let command = command.trim();
    let input = parse_command(command);

    if matches!(input, CmdIn::Empty) {
        return CmdOut::Text(
            append_finished_jobs(String::new())
        );
    }
    if should_record {
        record_command(command);
    }


    let output = run_input(input);
    match output {
        CmdOut::Text(text) => CmdOut::Text(
            append_finished_jobs(text)
        ),
        output => output,
    }
}

fn run_input(input: CmdIn) -> CmdOut {
    match input {
        CmdIn::Empty => CmdOut::Text(String::new()),
        CmdIn::Exit => CmdOut::Exit,
        CmdIn::Clear => CmdOut::Clear,
        CmdIn::ClearLine => CmdOut::ClearLine,
        CmdIn::Pwd => CmdOut::Text(pwd()),
        CmdIn::Cd(path) => CmdOut::Text(cd(path.as_deref())),
        CmdIn::Spawn(command) => CmdOut::Text(spawn_bg_command(command)),
        CmdIn::Session => { CmdOut::Text( with_manager(|manager| 
            sessions(manager, CURRENT_SESSION)
        ))}
        CmdIn::Jobs => CmdOut::Text(with_manager(|manager| {
            jobs(&mut manager.sessions[CURRENT_SESSION])
        })),
        CmdIn::External { command, args } => { CmdOut::Text(
            external_command(&command, &args)
        )}
    }
}

fn external_command(command: &str, args: &[String]) -> String {
    let mut process = std::process::Command::new(command);
    ls(&mut process, command, args);

    match process.output() {
        Ok(output) => {
            let mut text = String::new();
            text.push_str(&String::from_utf8_lossy(&output.stdout));
            text.push_str(&String::from_utf8_lossy(&output.stderr));

            if text.trim().is_empty() && !output.status.success() {
                return CmdOut::Error {
                    command: command.to_string(),
                    message: output.status.to_string(),
                }
                .into_string();
            }
            text
        }
        Err(message) => CmdOut::Error {
            command: command.to_string(),
            message: message.to_string(),
        }
        .into_string(),
    }
}
