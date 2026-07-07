pub(crate) enum RecordHistory {
    Yes,
    No,
}

impl RecordHistory {
    pub(crate) fn record(self) -> bool {
        matches!(self, RecordHistory::Yes)
    }
}
