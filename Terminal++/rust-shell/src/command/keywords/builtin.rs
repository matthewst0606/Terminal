use crate::command::output::{DirectoryEntry, Output};
use std::fs::File;
use std::path::{Path, PathBuf};

pub(crate) enum Builtin {
    Exit,
    Clear,
    ClearLine,
    Touch(Option<String>),
    Session,
    Jobs,
    Pwd,
    Ls,
    Cd(Option<String>),
    Spawn(String),
}

impl Builtin {
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
            let kind = if path.is_dir() { "directory" } else { "file" };

            entries.push(DirectoryEntry {
                name: entry.file_name().to_string_lossy().to_string(),
                path: path.to_string_lossy().to_string(),
                kind: kind.to_string(),
            });
        }

        Output::Listing { entries }
    }

    pub(crate) fn pwd(current_dir: &Path) -> Output {
        Output::Text {
            text: current_dir.display().to_string(),
        }
    }

    pub(crate) fn touch(current_dir: &Path, filename: Option<String>) -> Output {
        let Some(filename) = filename else {
            return Output::Error {
                command: "touch".to_string(),
                message: "missing filename".to_string(),
            };
        };

        match File::create(current_dir.join(filename)) {
            Ok(_) => Output::Text {
                text: String::new(),
            },

            Err(error) => Output::Error {
                command: "touch".to_string(),
                message: error.to_string(),
            },
        }
    }

    pub(crate) fn cd(current_dir: &Path, path: Option<&str>) -> Result<PathBuf, String> {
        let Some(path) = path else {
            return Err("missing path".to_string());
        };

        let requested_path = Path::new(path);
        let new_dir: PathBuf;

        if requested_path.is_absolute() {
            new_dir = requested_path.to_path_buf();
        } else {
            new_dir = current_dir.join(requested_path);
        };

        if !new_dir.exists() {
            return Err("directory does not exist".to_string());
        } else if !new_dir.is_dir() {
            return Err("path is not a directory".to_string());
        }

        match new_dir.canonicalize() {
            Ok(path) => Ok(path),
            Err(error) => Err(error.to_string()),
        }
    }
}
