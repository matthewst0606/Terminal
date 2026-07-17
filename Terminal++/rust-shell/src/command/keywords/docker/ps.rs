use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct DockerPsEntry {
    #[serde(rename = "Names")]
    pub container: String,

    #[serde(rename = "ID")]
    pub id: String,

    #[serde(rename = "Image")]
    pub image: String,

    #[serde(rename = "Status")]
    pub status: String,

    #[serde(rename = "Ports")]
    pub ports: String,
}
