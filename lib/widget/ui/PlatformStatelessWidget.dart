import 'package:eps_open_api_reference_app/widget/ui/PlatformWidget.dart';
import 'package:flutter/widgets.dart';

class PlatformStatelessWidget extends StatelessWidget with PlatformWidget {
  final PlatformSelector platform;

  PlatformStatelessWidget({
    Key key,
    this.platform = PlatformSelector.autodetect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return super.onBuildPlatformWidget(context, platform: platform);
  }
}
