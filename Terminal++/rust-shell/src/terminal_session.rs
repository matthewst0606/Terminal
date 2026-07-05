
use std::thread;
use uuid::{Uuid};


// --------- public ---------
#[derive(Debug)]
pub struct TerminalSession {
    pub id: Uuid,
    pub history: Vec<String>,
    pub current_dir: String,
    pub jobs: Vec<thread::JoinHandle<String>>
}

pub fn create_session() -> TerminalSession {
    initialize_session()
}

pub fn finished_jobs_output(session: &mut TerminalSession) -> String {
    print_finished_jobs(session)
}


// --------- private ---------
fn initialize_session() -> TerminalSession {
    let session = TerminalSession { 
        id: Uuid::new_v4(),
        history: Vec::new(), 
        current_dir: String::new(),
        jobs: Vec::new(),
    };
    session  
}


fn print_finished_jobs(session: &mut TerminalSession) -> String {
    let mut i = 0;
    let mut text = String::new();

    while i < session.jobs.len() {
        if session.jobs[i].is_finished() {
            let handle = session.jobs.remove(i);
            let output = handle.join().unwrap();

            text.push_str("background command finished!\n");
            text.push_str(&output);
            if !output.ends_with('\n') {
                text.push('\n');
            }
        } else { 
            i += 1; 
        }
    }
    text
}

