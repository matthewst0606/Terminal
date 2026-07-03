use std::{io::Write};
use rust_shell::terminal_execute;


fn main() {
    let mut history: Vec<String> = Vec::new();

    loop {
        print!(">> ");
        std::io::stdout().flush().unwrap();

        let mut input = String::new();
        std::io::stdin().read_line(&mut input).unwrap();

        let command = input.trim();
        if command == "exit" || command == "quit" {
            break;
        }

        let output: String = terminal_execute(command.to_string());
           history.push(command.to_string());

        if !output.is_empty() {
            print!("{}", output);
            if !output.ends_with('\n') {
                println!();
            }
            std::io::stdout().flush().unwrap();
            history.push(command.to_string());

        }
        print!("history: ");
        for i in &history {
            print!("{} ",i);

        }
        println!();

    }
}
