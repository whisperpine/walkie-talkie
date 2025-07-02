use async_trait::async_trait;
use axum::extract::*;
use axum_extra::extract::{CookieJar, Host};
use bytes::Bytes;
use http::Method;
use serde::{Deserialize, Serialize};

use crate::{models, types::*};

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[must_use]
#[allow(clippy::large_enum_variant)]
pub enum ListChannelsResponse {
    /// Successful response with list of users
    Status200_SuccessfulResponseWithListOfUsers(Vec<models::Channel>),
    /// Channels not found
    Status404_ChannelsNotFound,
}

/// Channels
#[async_trait]
#[allow(clippy::ptr_arg)]
pub trait Channels<E: std::fmt::Debug + Send + Sync + 'static = ()>:
    super::ErrorHandler<E>
{
    /// List all channels.
    ///
    /// ListChannels - GET /channels
    async fn list_channels(
        &self,
        method: &Method,
        host: &Host,
        cookies: &CookieJar,
    ) -> Result<ListChannelsResponse, E>;
}
