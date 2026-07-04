#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        fn terminal_execute(command: String) -> String;
        fn terminal_history(command: String) -> Vec<String>;
    }
}

// --------- public functions ---------
pub fn terminal_execute(command: String) -> String {
    run_command(&command)
}

pub fn terminal_history(command: String) -> Vec<String> {
    let mut history: Vec<String> = Vec::new();
    history.push(command);
    history
}


// --------- private functions ---------
fn run_command(command: &str) -> String {
    let parsed_tokens = parse_command(command);

    if parsed_tokens.is_empty() {
        return String::new();
    }


    let path = parsed_tokens.get(1).map(String::as_str);

    match parsed_tokens[0].as_str() {
        "exit" | "quit" => "Close the app window to exit.".to_string(),
        "clear" => clear(),
        "clearline" => clear_line(),
        "pwd" => current_directory(),
        "cd" => change_directory(path),
        _ => run_external_command(&parsed_tokens),
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
// clears the terminal
fn clear() -> String {
    "__CLEAR__".to_string()
}

// clears the previous line
fn clear_line() -> String {
    "__CLEARLINE__".to_string()
}

// displays a red error message
fn red_err() -> String {
    "\x1B[31merror:\x1B[0m".to_string()
}

// gets the current directory
fn current_directory() -> String {
    match std::env::current_dir() {
        Ok(path) => path.display().to_string(),
        Err(error) => format!("pwd failed: {}", error),
    }
}


// changes the current directory
fn change_directory(path: Option<&str>) -> String {
    let Some(path) = path else {
        return "cd failed: missing path".to_string();
    };

    match std::env::set_current_dir(path) {
        Ok(()) => String::new(),
        Err(error) => format!("cd failed: {}", error),
    }
}

fn ls(process: &mut std::process::Command, command: &str, args: &[String]) {
    if command == "ls" && args.is_empty() {
        let _ = &process.arg("-C");
    } 
    else {
        let _ = &process.args(args.iter().map(String::as_str));
    }
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
                return format!("{} exited with {}", command, output.status);
            }
            else { text }
        }
        Err(error) => format!("{} {} failed: {}", red_err(), command, error),
    }
}
