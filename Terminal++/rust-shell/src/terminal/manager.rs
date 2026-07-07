use crate::terminal::session::TerminalSession;

pub(crate) struct TerminalManager {
    pub sessions: Vec<TerminalSession>,
}

impl TerminalManager {
    pub(crate) fn new() -> Self {
        let mut manager = Self {
            sessions: Vec::new(),
        };

        manager.sessions.push(TerminalSession::new());
        manager
    }
}
