use serde::Serialize;
const RESET: &str = "\x1b[0m";
const RED: &str = "\x1b[31m";
const YELLOW: &str = "\x1b[33m";
const BOLD: &str = "\x1b[1m";

#[derive(Debug, Serialize)]
pub(crate) struct DirectoryEntry {
    pub name: String,
    pub path: String,
    pub kind: String,
}

#[derive(Debug, Serialize)]
#[serde(tag = "kind")]
pub(crate) enum Output {
    #[serde(rename = "text")]
    Text { text: String },

    #[serde(rename = "external")]
    External {
        stdout: String,
        stderr: String,
        exit_code: Option<i32>,
    },

    #[serde(rename = "exit")]
    Exit,

    #[serde(rename = "clear")]
    Clear,

    #[serde(rename = "clearline")]
    ClearLine,

    #[serde(rename = "listing")]
    Listing { entries: Vec<DirectoryEntry> },

    #[serde(rename = "error")]
    Error { command: String, message: String },
}

// matches the output to a string.
// text and error will be displayed inside the ui of the
// swift app, while other commands, e.g. exit, will be used
// to perform some function
impl Output {
    pub(crate) fn string(self) -> String {
        serde_json::to_string(&self).expect("Output should always be serializable")
    }

    pub(crate) fn terminal_text(self) -> String {
        match self {
            Self::Exit => String::new(),
            Self::Clear => String::new(),
            Self::ClearLine => String::new(),
            Self::Listing { entries } => entries
                .iter()
                .map(|entry| format!("{}\n", entry.name))
                .collect(),

            Self::Text { text } => text,

            Self::External { stdout, stderr, .. } => format!("{stdout}{stderr}"),

            Self::Error { command, message } => {
                OutputFormatter::format_error_message(command, message)
            }
        }
    }
}

struct OutputFormatter {}
impl OutputFormatter {
    pub(crate) fn format_error_message(command: String, message: String) -> String {
        format!(
            "{BOLD}{RED}Error:{RESET} {YELLOW}{}{RESET}, {}",
            command, message
        )
    }
}
