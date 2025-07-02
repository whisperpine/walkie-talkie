/// A handy type alias for `Result<T, wt-rest-api::Error>`.
pub(crate) type Result<T> = std::result::Result<T, Error>;

/// Enumeration of errors that can occur in this crate.
#[derive(Debug, thiserror::Error)]
pub(crate) enum Error {
    // todo
}
