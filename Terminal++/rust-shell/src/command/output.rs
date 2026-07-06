pub(crate) enum Output {
    Text(String),
    Exit,
    Clear,
    ClearLine,
    Error { command: String, message: String },
}

// matches the output to a string.
// text and error will be displayed inside the ui of the
// swift app, while other commands, e.g. exit, will be used
// to perform some function
impl Output {
    pub(crate) fn string(self) -> String {
        match self {
            Output::Text(text) => text,
            Output::Exit => "__EXIT__".to_string(),
            Output::Clear => "__CLEAR__".to_string(),
            Output::ClearLine => "__CLEARLINE__".to_string(),
            Output::Error { command, message } => {
                format!("__ERROR__|{}|{}", command, message)
            }
        }
    }
}
