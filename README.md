# ePayService Open Banking Reference Implementation Sample

Flutter Code sample for helping TPPs and ASPSP using the ePayService Open Banking reference implementation platform.

## How to use the application ?

- First of all you must be registered at [ePayService](https://online.epayservices.com/) as user.
- Go to [ePayServiceOpenApi](https://online.epayservices.com/open_api/developers/sign_up) and register new application for getting [clientID] and [client secret]. 
- Use "epayserviceApp://epyservice_openbanking.com" for [Redirect URI]
- Open flutter project and create empty flutter file in [lib] directory.
- Fill this file with text below and insert secret and client id to accordingly fields

```dart
import 'package:eps_open_api_reference_app/repository/EnvVarHolder.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  EnvVarHolder().env.addAll({"EPS_DEMO_CLIENT_ID":"",
                             "EPS_DEMO_CLIENT_ID_SECRET":""});
  setupApplication();

  runApp(WidgetApplication());
}
```
- Create new "Run/Debug" configuration and "Dart entrypoint" by this file
- Run flutter project and enjoy

## License
[MIT](https://choosealicense.com/licenses/mit/)
