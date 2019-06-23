import 'package:eps_open_api_reference_app/widget/ui/WidgetLogo.dart';
import 'package:flutter/widgets.dart';

class WidgetScreenWithLogo extends StatelessWidget {
  final Widget _child;
  final Color _color;

  WidgetScreenWithLogo({
    @required Widget child,
    Color color,
  })  : _child = child,
        _color = color;

  @override
  Widget build(BuildContext context) {
    var widgetList = List<Widget>();

    widgetList.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: WidgetLogo(
          color: _color,
        ),
      ),
    );

    if (_child != null) {
      widgetList.add(
        Expanded(
          child: _child,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.down,
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgetList,
    );
  }
}
