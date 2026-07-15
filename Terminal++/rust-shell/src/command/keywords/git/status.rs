use serde::Serialize;

#[derive(Debug, Serialize)]
pub(crate) struct GitStatusEntry {
    pub path: String,
    pub status: String,
}
