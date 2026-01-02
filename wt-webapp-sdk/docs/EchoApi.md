# EchoApi

All URIs are relative to *http://localhost:8080*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**echoBack**](EchoApi.md#echoback) | **POST** /echo | Echo the request body |



## echoBack

> string echoBack(body)

Echo the request body

### Example

```ts
import {
  Configuration,
  EchoApi,
} from '';
import type { EchoBackRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new EchoApi();

  const body = {
    // string (optional)
    body: body_example,
  } satisfies EchoBackRequest;

  try {
    const data = await api.echoBack(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **body** | `string` |  | [Optional] |

### Return type

**string**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `text/plain`
- **Accept**: `text/plain`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Successful response |  -  |
| **400** | Bad request |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

