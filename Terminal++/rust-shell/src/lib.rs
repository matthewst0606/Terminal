mod command;
mod record_history;
mod shell;
mod terminal;



use shell::with_shell;

#[swift_bridge::bridge]

mod ffi {
    extern "Rust" {
        fn terminal_execute(command: String) -> String;
        fn terminal_history(command: String) -> Vec<String>;
    }
}

pub fn terminal_execute(command: String) -> String {
    with_shell(|shell| shell.run(command))
}

pub fn terminal_history(command: String) -> Vec<String> {
    with_shell(|shell| shell.history(command))
}
