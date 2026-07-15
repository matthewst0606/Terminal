
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct GitPushEntry {
    pub remote: String,
    pub branch: String,
    pub commits_pushed: usize,
    pub message: String,
}