import 'package:flutter/widgets.dart';

class WidgetScreenWithScroll extends StatelessWidget {
  final Widget _child;

  const WidgetScreenWithScroll({Key key, @required Widget child})
      : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: boxConstraints.maxHeight),
                child: IntrinsicHeight(
                  child: _child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
