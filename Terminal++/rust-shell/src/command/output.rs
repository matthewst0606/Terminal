

use serde_json::json;
use serde::Serialize;

const RESET: &str = "\x1b[0m";
const RED: &str = "\x1b[31m";
const YELLOW: &str = "\x1b[33m";
const GREEN: &str = "\x1b[32m";
const CYAN: &str = "\x1b[36m";
const BLUE: &str = "\x1b[34m";
const MAGENTA: &str = "\x1b[35m";
const BOLD: &str = "\x1b[1m";
const DIM: &str = "\x1b[2m";


#[derive(Debug, Serialize)]
pub(crate) struct DirectoryEntry {
    pub name: String,
    pub path: String,
    pub kind: String,
}


#[derive(Debug)]
pub(crate) enum Output {
    Text(String),
    Exit,
    Clear,
    ClearLine,
    Listing {
        entries: Vec<DirectoryEntry>,
    },
    Error { 
        command: String, 
        message: String 
    },
}

// matches the output to a string.
// text and error will be displayed inside the ui of the
// swift app, while other commands, e.g. exit, will be used
// to perform some function
impl Output {
    pub(crate) fn string(self) -> String {
        let value = match self {
            Self::Text(text) => json!({
                "kind": "text",
                "text": text
            }),
            Self::Exit => json!({
                "kind": "exit"
            }),
            Self::Clear => json!({
                "kind": "clear"
            }),
            Self::ClearLine => json!({
                "kind": "clearline"
            }),
            Self::Listing { entries } => json!({
                "kind": "listing",
                "entries": entries,
            }),
            Self::Error { command, message } => json!({
                "kind": "error",
                "command": command,
                "message": message
            }),

        };

        value.to_string()
    }

    pub(crate) fn terminal_text(self) -> String {
        match self {
            Self::Text(text) => text,
            Self::Error { command, message } => {
                format!(
                    "{BOLD}{RED}Error:{RESET} {YELLOW}{}{RESET}, {}",
                    command,
                    message
                )
            }
            Self::Exit => String::new(),
            Self::Clear => String::new(),
            Self::ClearLine => String::new(),
            Self::Listing { entries } => {
                    entries
                        .iter()
                        .map(|entry| format!("{}\n", entry.name))
                        .collect()
                
            }
        }
    }
}
