use crate::command::builtin::Builtin;
use crate::command::output::Output;

pub(crate) struct External {
    command: String,
    args: Vec<String>,
}

impl External {
    // initialize External
    pub(crate) fn new(command: String, args: Vec<String>) -> External {
        External {
            command: command,
            args: args,
        }
    }

    // run an external command
    pub(crate) fn run(&self) -> String {
        let mut process = std::process::Command::new(&self.command);
        Builtin::ls(&mut process, &self.command, &self.args);

        match process.output() {
            Ok(output) => {
                let mut text = String::new();
                text.push_str(&String::from_utf8_lossy(&output.stdout));
                text.push_str(&String::from_utf8_lossy(&output.stderr));

                if text.trim().is_empty() && !output.status.success() {
                    return Output::Error {
                        command: self.command.to_string(),
                        message: output.status.to_string(),
                    }
                    .string();
                }
                text
            }
            Err(message) => Output::Error {
                command: self.command.to_string(),
                message: message.to_string(),
            }
            .string(),
        }
    }
}
