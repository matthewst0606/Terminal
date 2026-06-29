use std::io::Write;

use rust_shell::terminal_execute;

fn main() {
    loop {
        print!(">> ");
        std::io::stdout().flush().unwrap();

        let mut input = String::new();
        std::io::stdin().read_line(&mut input).unwrap();

        let command = input.trim();
        if command == "exit" || command == "quit" {
            break;
        }

        let output = terminal_execute(command.to_string());
        if !output.is_empty() {
            println!("{}", output);
        }
    }
}
