use axum_extra::extract::{CookieJar, Host};
use http::Method;
use wt_rest_stubs::apis::echo::EchoBackResponse;

#[async_trait::async_trait]
impl wt_rest_stubs::apis::echo::Echo<crate::Error> for crate::ServerImpl {
    async fn echo_back(
        &self,
        _method: &Method,
        _host: &Host,
        _cookies: &CookieJar,
        body: &String,
    ) -> crate::Result<EchoBackResponse> {
        tracing::trace!(%body, "#echo_back#");
        let resp = EchoBackResponse::Status200_SuccessfulResponse(body.clone());
        Ok(resp)
    }
}
