mod command;
mod shell;
mod terminal;
mod record_history;

use shell::Shell;

#[swift_bridge::bridge]

mod ffi {
    extern "Rust" {
        fn terminal_execute(command: String) -> String;
        fn terminal_history(command: String) -> Vec<String>;
    }
}

pub fn terminal_execute(command: String) -> String {
    Shell::new().run(command)
}

pub fn terminal_history(command: String) -> Vec<String> {
    Shell::new().history(command)
}
