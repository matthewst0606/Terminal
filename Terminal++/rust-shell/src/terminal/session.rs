use std::thread;
use uuid::Uuid;

#[derive(Debug)]
pub(crate) struct TerminalSession {
    pub id: Uuid,
    pub history: Vec<String>,
    pub current_dir: String,
    pub jobs: Vec<thread::JoinHandle<String>>,
}

impl TerminalSession {
    pub(crate) fn new() -> Self {
        let session = Self {
            id: Uuid::new_v4(),
            history: Vec::new(),
            current_dir: String::new(),
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
                let output = handle.join().unwrap();

                text.push_str("background command finished!\n");
                text.push_str(&output);

                if !output.ends_with('\n') {
                    text.push('\n');
                }
            } else {
                i += 1;
            }
        }
        text
    }
}
