use rust_shell::terminal_execute;
use std::io::Write;

fn main() {
    loop {
        print!(">> ");
        std::io::stdout().flush().unwrap();

        let mut stdin = String::new();
        std::io::stdin().read_line(&mut stdin).unwrap();

        let stdout = terminal_execute(stdin.trim().to_string());

        if !stdout.is_empty() {
            print!("{}", stdout);
            if !stdout.ends_with('\n') {
                println!();
            }
        }
    }
}
