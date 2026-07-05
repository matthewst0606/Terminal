// Command Output
pub enum CmdOut {
    Text(String),
    Exit,
    Clear,
    ClearLine,
    Error { command: String, message: String },
}

impl CmdOut {
    pub fn into_string(self) -> String {
        match self {
            CmdOut::Text(text) => text,
            CmdOut::Exit => "__EXIT__".to_string(),
            CmdOut::Clear => "__CLEAR__".to_string(),
            CmdOut::ClearLine => "__CLEARLINE__".to_string(),
            CmdOut::Error { command, message } => {
                format!("__ERROR__|{}|{}", command, message)
            }
        }
    }
}
