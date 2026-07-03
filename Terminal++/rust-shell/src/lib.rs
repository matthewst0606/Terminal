
#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        fn terminal_execute(command: String) -> String;
        fn terminal_history(command: String) -> Vec<String>;
    }
}

pub fn terminal_execute(command: String) -> String {
    run_command(&command)
}

pub fn terminal_history(command: String) -> Vec<String> {
    let mut history: Vec<String> = Vec::new();
    history.push(command);
    history
}








fn run_command(command: &str) -> String {
    let tokens: Vec<&str> = command.split_whitespace().collect();

    if tokens.is_empty() {
        return String::new();
    }


    match tokens[0] {
        "exit" | "quit" => "Close the app window to exit.".to_string(),
        "clear" => clear(),
        "clearline" => clear_line(),
        "pwd" => current_directory(),
        "cd" => change_directory(tokens.get(1).copied()),
        _ => run_external_command(&tokens),
    }
}



// fn help() {

// }


fn clear() -> String {
    "__CLEAR__".to_string()
}

fn clear_line() -> String {
    "__CLEARLINE__".to_string()
}


fn red_err() -> String {
    "\x1B[31merror:\x1B[0m".to_string()
}

fn current_directory() -> String {
    match std::env::current_dir() {
        Ok(path) => path.display().to_string(),
        Err(error) => format!("pwd failed: {}", error),
    }
}



fn change_directory(path: Option<&str>) -> String {
    let Some(path) = path else {
        return "cd failed: missing path".to_string();
    };

    match std::env::set_current_dir(path) {
        Ok(()) => String::new(),
        Err(error) => format!("cd failed: {}", error),
    }
}

fn run_external_command(tokens: &[&str]) -> String {
    let command = tokens[0];
    let args = &tokens[1..];


    let args: Vec<&str> = if command == "ls" && args.is_empty() 
        { vec!["-C"] }
    else 
        {args.to_vec() };

    match std::process::Command::new(command).args(args).output() {
        Ok(output) => {

            let mut text = String::new();
            text.push_str(&String::from_utf8_lossy(&output.stdout));
            text.push_str(&String::from_utf8_lossy(&output.stderr));
            


            if text.trim().is_empty() && !output.status.success() {
                return format!("{} exited with {}", command, output.status);
            }
            text
        }
        Err(error) => format!("{} {} failed: {}", red_err(), command, error),
    }
}
