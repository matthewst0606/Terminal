use crate::command::output::Output;
use std::{env, path::Path};

pub(crate) struct External {
    command: String,
    args: Vec<String>,
}

impl External {
    // initialize External
    pub(crate) fn new(command: String, args: Vec<String>) -> Self {
        Self { command, args }
    }

    // run an external command
    pub(crate) fn run(&self, current_dir: &Path) -> Output {
        let mut process = std::process::Command::new(&self.command);
        
        process.current_dir(current_dir);

        if self.command == "git" {
            process.arg("-c").arg("color.ui=always");
        }
        
        let mut paths = vec![
            "/usr/local/bin".into(),
            "/opt/homebrew/bin".into(),
        ];

        if let Some(existing_path) = env::var_os("PATH") {
            paths.extend(env::split_paths(&existing_path));
        }

        let path = env::join_paths(paths)
            .expect("failed to build PATH");

        process
            .env("PATH", path)
            .env("TERM", "xterm-256color")
            .env("CLICOLOR_FORCE", "1")
            .env("FORCE_COLOR", "1");

        process.args(self.args.iter().map(String::as_str));

        
        match process.output() {
            Ok(output) => {
                let mut text = String::new();
                text.push_str(&String::from_utf8_lossy(&output.stdout));
                text.push_str(&String::from_utf8_lossy(&output.stderr));

                if text.trim().is_empty() && !output.status.success() {
                    return Output::Error {
                        command: self.command.to_string(),
                        message: output.status.to_string(),
                    };
                }
                Output::Text(text)

            }
            Err(message) => Output::Error {
                command: self.command.to_string(),
                message: message.to_string(),
            },
        }
    }
    
}
