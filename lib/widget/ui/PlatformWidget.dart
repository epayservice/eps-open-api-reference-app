import 'dart:io';

import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:flutter/widgets.dart';

export 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';

mixin PlatformWidget {
  Widget onBuildAndroidWidget(BuildContext context) {
    throw Exception("Android widget not implemented");
  }

  Widget onBuildIOSWidget(BuildContext context) {
    throw Exception("iOS widget not implemented");
  }

  Widget onBuildFuchsiaWidget(BuildContext context) {
    throw Exception("Fuchsia widget not implemented");
  }

  Widget onBuildMacOSWidget(BuildContext context) {
    return onBuildIOSWidget(context);
    //    throw Exception("macOS widget not implemented");
  }

  Widget onBuildWidowsWidget(BuildContext context) {
    throw Exception("Windows widget not implemented");
  }

  Widget onBuildLinuxWidget(BuildContext context) {
    throw Exception("Linux widget not implemented");
  }

  Widget onBuildUnknownPlatformWidget(BuildContext context) {
    throw Exception("Unknown platform widget not implemented");
  }

  Widget onBuildPlatformWidget(BuildContext context, {PlatformSelector platform = PlatformSelector.autodetect}) {
    if (platform == null) {
      platform = PlatformSelector.autodetect;
    }

    if ((platform == PlatformSelector.autodetect && Platform.isAndroid) || platform == PlatformSelector.android) {
      return onBuildAndroidWidget(context);
    } else if ((platform == PlatformSelector.autodetect && Platform.isIOS) || platform == PlatformSelector.ios) {
      return onBuildIOSWidget(context);
    } else if ((platform == PlatformSelector.autodetect && Platform.isFuchsia) || platform == PlatformSelector.fuchsia) {
      return onBuildFuchsiaWidget(context);
    } else if ((platform == PlatformSelector.autodetect && Platform.isMacOS) || platform == PlatformSelector.macOS) {
      return onBuildMacOSWidget(context);
    } else if ((platform == PlatformSelector.autodetect && Platform.isWindows) || platform == PlatformSelector.windows) {
      return onBuildWidowsWidget(context);
    } else if ((platform == PlatformSelector.autodetect && Platform.isLinux) || platform == PlatformSelector.linux) {
      return onBuildLinuxWidget(context);
    }

    return onBuildUnknownPlatformWidget(context);
  }
}
