
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct GitCheckoutEntry {
    pub previous_branch: String,
    pub branch: String,
    pub created: bool,
    pub detached: bool,
}


