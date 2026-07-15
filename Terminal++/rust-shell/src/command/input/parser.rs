use crate::command::{
    input::{input::Input, lexer::Lexer},
    keywords::{builtin::Builtin, external::ExternalCommand},
};
use std::path::Path;

pub(crate) fn parse_input(command: &str, current_dir: &Path) -> Input {
    let tokens = Lexer::tokenize_input(command);

    let Some((command, args)) = tokens.split_first() else {
        return Input::Empty;
    };

    if let Some(builtin) = parse_builtin(command, args) {
        return Input::Builtin(builtin);
    }

    if args.is_empty() && current_dir.join(command).is_dir() {
        return Input::Builtin(Builtin::Cd(Some(command.clone().to_string())));
    }

    Input::External(ExternalCommand::new(
        command.clone().to_string(),
        args.to_vec(),
    ))
}

pub(crate) fn parse_builtin(command: &str, args: &[String]) -> Option<Builtin> {
    match command {
        "exit" | "quit" => Some(Builtin::Exit),
        "dir" | "pwd" => Some(Builtin::Pwd),
        "cd" => Some(Builtin::Cd(args.first().cloned())),
        "ls" | "list" => Some(Builtin::Ls),
        "clear" => Some(Builtin::Clear),
        "clearline" => Some(Builtin::ClearLine),
        "touch" => Some(Builtin::Touch(args.first().cloned())),
        "spawn" => Some(Builtin::Spawn(args.join(" "))),
        "sessions" | "session" => Some(Builtin::Session),
        "jobs" | "job" => Some(Builtin::Jobs),
        _ => None,
    }
}
