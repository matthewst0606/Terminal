use crate::command::output::{Output, DirectoryEntry};
use std::path::{Path, PathBuf};
pub(crate) enum Builtin {
    Exit,
    Clear,
    ClearLine,
    Session,
    Jobs,
    Pwd,
    Ls,
    Cd(Option<String>),
    Spawn(String),
}

impl Builtin {
    pub(crate) fn parse(command: &str, args: &[String]) -> Option<Builtin> {
        match command {
            "exit" | "quit" => Some(Self::Exit),
            "dir" | "pwd" => Some(Self::Pwd),
            "cd" => Some(Self::Cd(args.first().cloned())),
            "ls" | "list" => Some(Self::Ls),
            "clear" => Some(Self::Clear),
            "clearline" => Some(Self::ClearLine),
            "spawn" => Some(Self::Spawn(args.join(" "))),
            "sessions" | "session" => Some(Self::Session),
            "jobs" | "job" => Some(Self::Jobs),
            _ => None,
        }
    }


    // formats "ls" in columns unless additional
    // arguments are provided
    pub(crate) fn ls(current_dir: &Path) -> Output {
        
        let dir = match std::fs::read_dir(current_dir) {
            Ok(dir) => dir,
            Err(error) => {
                return Output::Error {
                    command: "ls".to_string(),
                    message: error.to_string(),
                };
            }
        };

        let mut entries = Vec::new();

        for entry in dir.flatten() {
            let path = entry.path();
            let kind = if path.is_dir() { "directory" }
            else { "file" };

            entries.push(DirectoryEntry {
                name: entry.file_name().to_string_lossy().to_string(),
                path: path.to_string_lossy().to_string(),
                kind: kind.to_string(),
            });
        }
        
        Output::Listing { entries }
    }


    // gets the current directory
    pub(crate) fn pwd(current_dir: &Path) -> Output {
        
        match std::env::current_dir() {
            Ok(_) => Output::Text(current_dir.display().to_string()),
            Err(message) => Output::Error {
                command: "pwd".to_string(),
                message: message.to_string(),
            },
        }
    }

    // changes the current directory
    pub(crate) fn cd(current_dir: &Path, path: Option<&str>) -> Result<PathBuf, String> {
        let Some(path) = path else { return Err("missing path".to_string()); };


        let requested_path = Path::new(path);

        let new_dir = if requested_path.is_absolute() {
            requested_path.to_path_buf()
        } else {
            current_dir.join(requested_path)
        };


        if !new_dir.exists() {
            return Err("directory does not exist".to_string());
        }
        if !new_dir.is_dir() {
            return Err("path is not a directory".to_string());
        }

        match new_dir.canonicalize() {
            Ok(path) => Ok(path),
            Err(error) => Err(error.to_string()),
        }
    }

}
