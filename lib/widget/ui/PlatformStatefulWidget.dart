import 'package:eps_open_api_reference_app/widget/ui/PlatformWidget.dart';
import 'package:flutter/widgets.dart';

class PlatformStatefulWidget extends StatefulWidget {
  final PlatformSelector platform;

  PlatformStatefulWidget({
    Key key,
    this.platform = PlatformSelector.autodetect,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlatformStatefulWidgetState();
  }
}

class _PlatformStatefulWidgetState extends State<PlatformStatefulWidget> with PlatformWidget {
  @override
  Widget build(BuildContext context) {
    return super.onBuildPlatformWidget(context, platform: widget.platform);
  }
}
