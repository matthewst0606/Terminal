use crate::terminal_session::TerminalSession;


pub struct TerminalManager {
    pub sessions: Vec<TerminalSession>
}

pub fn create_manager() -> TerminalManager {
    TerminalManager {
        sessions: Vec::new(),
    }
}