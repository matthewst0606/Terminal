use std::io::Write;
use rust_shell::terminal_execute;

fn main() {
    loop {
        print!(">> ");
        std::io::stdout().flush().unwrap();

        let mut input = String::new();
        std::io::stdin().read_line(&mut input).unwrap();

        let output = terminal_execute(input.trim().to_string());
        
        
        
        if !output.is_empty() {
            print!("{}", output);
            if !output.ends_with('\n') {
                println!();
            }
        }
    }
}
