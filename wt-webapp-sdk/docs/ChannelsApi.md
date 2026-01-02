# ChannelsApi

All URIs are relative to *http://localhost:8080*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**listChannels**](ChannelsApi.md#listchannels) | **GET** /channels | List all channels |



## listChannels

> Array&lt;Channel&gt; listChannels()

List all channels

### Example

```ts
import {
  Configuration,
  ChannelsApi,
} from '';
import type { ListChannelsRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new ChannelsApi();

  try {
    const data = await api.listChannels();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**Array&lt;Channel&gt;**](Channel.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful response with list of users |  -  |
| **404** | Channels not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

