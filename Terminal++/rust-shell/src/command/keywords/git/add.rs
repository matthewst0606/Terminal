
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct GitAddEntry {
    pub path: String,
    pub staged: bool,
}