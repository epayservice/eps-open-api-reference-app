# ePayService Open Banking Reference Implementation Sample

Flutter Code sample for helping TPPs and ASPSP using the ePayService Open Banking reference implementation platform.

## How to use the application ?

- First of all you must be registered at [ePayService](https://online.epayservices.com/) as user.
- Go to [ePayServiceOpenApi](https://online.epayservices.com/open_api/developers/sign_up) and register new application for getting [clientID] and [client secret]. 
- Use "epayserviceApp://epyservice_openbanking.com" for [Redirect URI]
- Open flutter project and create file with name [local.dart] in [lib] directory.
- Fill [local.dart] file with text below and insert secret and client id to accordingly fields

```dart
class Epayservice {
static const clientId = "";
static const clientSecret = "";
static const redirectUri = "epayserviceApp://epyservice_openbanking.com";
}
```

- Run flutter project and enjoy

## License
[MIT](https://choosealicense.com/licenses/mit/)
