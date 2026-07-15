use crate::command::keywords::{builtin::Builtin, external::ExternalCommand};

pub(crate) enum Input {
    Empty,
    Builtin(Builtin),
    External(ExternalCommand),
}
