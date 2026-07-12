use serde_json::json;
use serde::{Deserialize, Serialize};

const RESET: &str = "\x1b[0m";
const RED: &str = "\x1b[31m";
const YELLOW: &str = "\x1b[33m";
// const GREEN: &str = "\x1b[32m";
// const CYAN: &str = "\x1b[36m";
// const BLUE: &str = "\x1b[34m";
// const MAGENTA: &str = "\x1b[35m";
const BOLD: &str = "\x1b[1m";
// const DIM: &str = "\x1b[2m";


#[derive(Debug, Serialize)]
pub(crate) struct DirectoryEntry {
    pub name: String,
    pub path: String,
    pub kind: String,
}

#[derive(Debug, Serialize)]
pub(crate) struct GitStatusEntry {
    pub path: String,
    pub status: String,
}



#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct DockerPsEntry {
    #[serde(rename = "Names")]
    pub container: String,
       
    #[serde(rename = "ID")]
    pub container_id: String,

    #[serde(rename = "Image")]
    pub image: String,

    #[serde(rename = "Status")]
    pub status: String,

    #[serde(rename = "Ports")]
    pub ports: String,
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
    GitStatus {
        branch: String,
        branch_status: String,
        entries: Vec<GitStatusEntry>,
    },
    DockerPs {
        entries: Vec<DockerPsEntry>
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

            Self::GitStatus { branch, branch_status, entries } => json!({
                "kind": "git_status",
                "branch": branch,
                "branch_status": branch_status,
                "git_status_entries": entries,
            }),

            Self::DockerPs { entries } => json!({
                "kind": "docker_ps",
                "docker_ps_entries": entries,

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
                
            Self::GitStatus { branch, entries, .. } => {
                let mut text = format!("Branch: {branch}\n");

                for entry in entries {
                    text.push_str(&format!("{}: {}\n", entry.status, entry.path));
                }

                text
            },

            Self::DockerPs { entries } => {
                let mut text = format!("");

                for entry in entries { 
                    text.push_str(&format!("{}: {}, {}, {}, {}\n", 
                        entry.container, 
                        entry.container_id,
                        entry.image,
                        entry.ports,
                        entry.status,
                    ));
                }

                text
            },
            
            Self::Listing { entries } => {
                entries
                    .iter()
                    .map(|entry| format!("{}\n", entry.name))
                    .collect()
                
            }
        }
    }


    
    pub(crate) fn parse_git_status(text: &str) -> Output {
        let mut lines = text.lines();

        let header = lines.next().unwrap_or("");

        let branch_status = header
            .strip_prefix("## ")
            .unwrap_or("")
            .to_string();

        let branch = branch_status
            .split("...")
            .next()
            .unwrap_or(&branch_status)
            .to_string();



        let entries = lines.filter_map(|line| {
            let code = line.get(..2)?;
            let path = line.get(3..)?;
            let status = match code {
                "??" => "untracked",
                code if code.as_bytes()[1] == b'D' =>  "deleted",
                code if code.as_bytes()[0] != b' ' => "staged",
                _ => "modified",
            };

            Some(GitStatusEntry {
                path: path.to_string(),
                status: status.to_string(),
            })
        })
        .collect();

        Output::GitStatus { branch, branch_status, entries }
    }

    pub(crate) fn parse_docker_ps(text: &str) -> Output {

    



        let entries = text
            .lines()
            .filter_map(|line| {
                match serde_json::from_str::<DockerPsEntry>(line) {
                    Ok(entry) => Some(entry),
                    Err(error) => {
                        eprintln!("Docker parse error: {error}");
                        eprintln!("{line}");
                        None
                    }
                }

            })
            .collect();


        Output::DockerPs { entries }
    }
}
