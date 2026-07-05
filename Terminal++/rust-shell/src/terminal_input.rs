pub enum CmdIn {
    Empty,
    Exit,
    Clear,
    ClearLine,
    Session,
    Jobs,
    Pwd,
    Cd(Option<String>),
    Spawn(String),
    External { command: String, args: Vec<String> },
}


pub fn parse_command(command: &str) -> CmdIn {
    let tokens = tokenize_command(command);

    if tokens.is_empty() {
        return CmdIn::Empty;
    }

    match tokens[0].as_str() {
        "exit" | "quit" => CmdIn::Exit,
        "clear" => CmdIn::Clear,
        "clearline" => CmdIn::ClearLine,
        "sessions" => CmdIn::Session,
        "jobs" => CmdIn::Jobs,
        "pwd" => CmdIn::Pwd,
        "cd" => CmdIn::Cd(tokens.get(1).cloned()),
        "spawn" => CmdIn::Spawn(tokens[1..].join(" ")),
        _ => CmdIn::External {
            command: tokens[0].clone(),
            args: tokens[1..].to_vec(),
        },
    }
}


// combines arguments that are wrapped in quotes
fn tokenize_command(command: &str) -> Vec<String> {
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
