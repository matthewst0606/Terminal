
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct GitCommitEntry {
    pub hash: String,
    pub message: String,
    pub branch: String,
    pub files_changed: usize,
    pub insertions: usize,
    pub deletions: usize,
}