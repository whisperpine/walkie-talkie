use axum_extra::extract::{CookieJar, Host};
use http::Method;
use wt_rest_stubs::apis::channels::ListChannelsResponse;
use wt_rest_stubs::models;

/// Channels
#[async_trait::async_trait]
impl wt_rest_stubs::apis::channels::Channels<crate::Error> for crate::ServerImpl {
    /// List all channels.
    ///
    /// ListChannels - GET /channels
    async fn list_channels(
        &self,
        _method: &Method,
        _host: &Host,
        _cookies: &CookieJar,
    ) -> crate::Result<ListChannelsResponse> {
        // todo
        tracing::warn!(
            "#list_channels# this function should be implemented later. now responding with mock data."
        );

        let channel_3 = models::Channel {
            channel_id: 3,
            channel_name: None,
        };
        let channel_5 = models::Channel {
            channel_id: 5,
            channel_name: None,
        };
        let channels = vec![channel_3, channel_5];
        Ok(ListChannelsResponse::Status200_SuccessfulResponseWithListOfUsers(channels))
    }
}
