use crate::terminal::session::TerminalSession;
use std::sync::{Mutex, OnceLock};

pub(crate) struct TerminalManager {
    pub sessions: Vec<TerminalSession>,
}

impl TerminalManager {
    fn new() -> TerminalManager {
        TerminalManager {
            sessions: Vec::new(),
        }
    }
}

pub(crate) fn with_manager<T>(action: impl FnOnce(&mut TerminalManager) -> T) -> T {
    let mut manager = manager()
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());

    action(&mut manager)
}

// initializes a global manager once
fn manager() -> &'static Mutex<TerminalManager> {
    static MANAGER: OnceLock<Mutex<TerminalManager>> = OnceLock::new();

    MANAGER.get_or_init(|| {
        let mut manager = TerminalManager::new();
        manager.sessions.push(TerminalSession::new());
        Mutex::new(manager)
    })
}
