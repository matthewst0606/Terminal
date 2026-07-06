use crate::command::builtin::Builtin;
use crate::command::external::External;
const DOUBLE_QUOTE: char = '"';
const SPACE: char = ' ';
const TAB: char = '\t';

pub(crate) enum Input {
    Empty,
    Builtin(Builtin),
    External(External),
}

impl Input {
    // tokenizes the input, and checks whether the input is empty
    // or the input contains any builtin keywords. If input does
    // not match any of the keywords, it will run an external command
    pub(crate) fn parse(command: &str) -> Input {
        let tokens = Input::tokenize(command);

        let Some((command, args)) = tokens.split_first() else {
            return Input::Empty;
        };
        if let Some(builtin) = Builtin::parse(command, args) {
            return Input::Builtin(builtin);
        }

        Input::External(External::new(command.clone(), args.to_vec()))
    }

    // combines arguments that are wrapped in quotes
    // e.g. echo "hello world" -> [hello world]
    fn tokenize(command: &str) -> Vec<String> {
        let mut tokens = Vec::new();
        let mut current = String::new();
        let mut in_quotes = false;

        for c in command.chars() {
            match c {
                DOUBLE_QUOTE => in_quotes = !in_quotes,
                SPACE | TAB if !in_quotes => {
                    if !current.is_empty() {
                        tokens.push(current);
                        current = String::new();
                    }
                }
                _ => current.push(c),
            }
        }

        if !current.is_empty() {
            tokens.push(current);
        }
        tokens
    }
}
