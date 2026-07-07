pub(crate) enum Output {
    Text(String),
    Exit,
    Clear,
    ClearLine,
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
        match self {
            Self::Text(text) => text,
            Self::Exit => "__EXIT__".to_string(),
            Self::Clear => "__CLEAR__".to_string(),
            Self::ClearLine => "__CLEARLINE__".to_string(),
            Self::Error { command, message } => {
                format!("__ERROR__|{}|{}", command, message)
            }
        }
    }
}
