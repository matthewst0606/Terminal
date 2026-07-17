use std::{path::PathBuf, thread};
use uuid::Uuid;

use crate::command::output::Output;

#[derive(Debug)]
pub(crate) struct TerminalSession {
    pub id: Uuid,
    pub history: Vec<String>,
    pub current_dir: PathBuf,
    pub jobs: Vec<thread::JoinHandle<Output>>,
}

impl TerminalSession {
    pub(crate) fn new() -> Self {
        let current_dir = std::env::var_os("HOME")
            .map(PathBuf::from)
            .filter(|path| path.is_dir())
            .or_else(|| std::env::current_dir().ok())
            .unwrap_or_else(|| PathBuf::from("/"));

        let session = Self {
            id: Uuid::new_v4(),
            history: Vec::new(),
            current_dir,
            jobs: Vec::new(),
        };
        session
    }

    pub(crate) fn output(&mut self) -> String {
        let mut i = 0;
        let mut text = String::new();

        while i < self.jobs.len() {
            if self.jobs[i].is_finished() {
                let handle = self.jobs.remove(i);

                let output = handle
                    .join()
                    .unwrap_or_else(|_| Output::Error {
                        command: "background".to_string(),
                        message: "job panicked".to_string(),
                    })
                    .terminal_text();

                text.push_str("\x1b[32mbackground command finished!\x1b[0m\n");

                if !output.is_empty() {
                    text.push_str(&output);
                }

                if !output.is_empty() && !output.ends_with('\n') {
                    text.push('\n');
                }
            } else {
                i += 1;
            }
        }
        text
    }
}
