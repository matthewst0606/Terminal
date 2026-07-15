use crate::command::output::Output;
use std::path::PathBuf;
use std::{
    env,
    ffi::OsString,
    path::Path,
    process::{Command, Output as ProcessOutput},
};

fn output_to_response(output: ProcessOutput) -> Output {
    Output::External {
        stdout: String::from_utf8_lossy(&output.stdout).into_owned(),
        stderr: String::from_utf8_lossy(&output.stderr).into_owned(),
        exit_code: output.status.code(),
    }
}

fn command_path() -> OsString {
    let mut paths = vec![
        PathBuf::from("/usr/local/bin"),
        PathBuf::from("/opt/homebrew/bin"),
    ];

    if let Some(existing_path) = env::var_os("PATH") {
        paths.extend(env::split_paths(&existing_path));
    }

    env::join_paths(paths).expect("failed to build PATH")
}

pub(crate) struct ExternalCommand {
    command: String,
    args: Vec<String>,
}

impl ExternalCommand {
    pub(crate) fn new(command: String, args: Vec<String>) -> Self {
        Self { command, args }
    }

    pub(crate) fn run(&self, current_dir: &Path) -> Output {
        match self.run_process(current_dir) {
            Ok(output) => output_to_response(output),
            Err(error) => Output::Error {
                command: self.command.clone(),
                message: error.to_string(),
            },
        }
    }

    fn run_process(&self, current_dir: &Path) -> std::io::Result<ProcessOutput> {
        let mut command = Command::new(&self.command);

        command
            .current_dir(current_dir)
            .env("PATH", command_path())
            .env("TERM", "xterm-256color");

        command.args(&self.args);
        command.output()
    }
}
