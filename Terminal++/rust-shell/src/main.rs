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
        let output: String = terminal_execute(command.to_string());

        if !output.is_empty() {
            print!("{}", output);
            if !output.ends_with('\n') {
                println!();
            }
            std::io::stdout().flush().unwrap();
            history.push(command.to_string());
        }

        print_output(&history);

    }
}




fn print_output(history:  &Vec<String>) {
    print!("history: [");
    for (index,item) in history.iter().enumerate() {
        if index > 0 {
            print!(", ");
        }

        print!("{}", item);
    }
    print!("]");
    println!();
}
