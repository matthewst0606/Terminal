use crate::command::output::{Output};
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



    fn run_git_status(&self, current_dir: &Path) -> Output {
        let output = std::process::Command::new("git")
            .args(["status", "--porcelain=v1", "--branch"])
            .current_dir(current_dir)
            .output();

        match output {
            Ok(output) => {
                if !output.status.success() {
                    return Output::Error {
                        command: "git status".to_string(),
                        message: String::from_utf8_lossy(&output.stderr).to_string(),
                    };
                }

                let text = String::from_utf8_lossy(&output.stdout);

                Output::parse_git_status(&text)
            }
            Err(error) => Output::Error {
                command: "git status".to_string(),
                message: error.to_string(),
            },
        }
    }

    fn run_docker_ps(&self, current_dir: &Path, path: &std::ffi::OsStr) -> Output {
        // let mut paths = vec![
        //     "/usr/local/bin".into(),
        //     "/opt/homebrew/bin".into(),
        // ];
        

        let output = std::process::Command::new("docker")
            .args(["ps", "--format", "{{json .}}"])
            .current_dir(current_dir)
            .env("PATH", path)
            .output();

        match output {
            Ok(output) => {
                if !output.status.success() {
                    return Output::Error {
                        command: "docker ps".to_string(),
                        message: String::from_utf8_lossy(&output.stderr).to_string(),
                    };
                }

                let text = String::from_utf8_lossy(&output.stdout);

                Output::parse_docker_ps(&text)
            }
            Err(error) 
            => Output::Error {
                command: "docker ps".to_string(),
                message: error.to_string(),
            },
        }
    }


    // run an external command
    pub(crate) fn run(&self, current_dir: &Path) -> Output {
        
        
        if self.command == "git" && self.args.len() == 1 && self.args[0] == "status" {
            return self.run_git_status(current_dir);
        }

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

        if self.command == "docker" && self.args.len() == 1 && self.args[0] == "ps" {
            return self.run_docker_ps(current_dir, &path);
        }
        

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
