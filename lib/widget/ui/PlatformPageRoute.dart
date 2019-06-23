import 'dart:io';

import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart' as widgets;

class PlatformPageRoute {
  static widgets.PageRoute build({
    @widgets.required widgets.Widget Function(widgets.BuildContext context) builder,
    bool fullscreenDialog = false,
  }) {
    if (Platform.isAndroid) {
      return material.MaterialPageRoute(builder: builder, fullscreenDialog: fullscreenDialog);
    } else if (Platform.isIOS || Platform.isMacOS) {
      return cupertino.CupertinoPageRoute(builder: builder, fullscreenDialog: fullscreenDialog);
    } else {
      return null;
    }
  }
}
