import 'dart:async';
import 'dart:io';

import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class ModalBottomSheet {
  static Future<T> show<T>({
    @required BuildContext context,
    @required Widget child,
    Color backgroundColor,
    double percent,
  }) {
    Widget widget = LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.minWidth,
            maxWidth: constraints.maxWidth,
            minHeight: constraints.minHeight,
            maxHeight: constraints.maxHeight * (percent ?? 0.85),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0),
              ),
            ),
            child: child,
          ),
        );
      },
    );

    if (Platform.isAndroid) {
      return _showModalBottomSheet<T>(
        context: context,
        builder: (context) {
          return widget;
        },
      );
    } else if (Platform.isIOS) {
      return cupertino.showCupertinoModalPopup<T>(
        context: context,
        builder: (context) {
          return widget;
        },
      );
    } else {
      return null;
    }
  }
}

Future<T> _showModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  assert(context != null);
  assert(builder != null);
  return Navigator.push(
      context,
      _ModalBottomSheetRoute<T>(
        builder: builder,
        theme: material.Theme.of(context, shadowThemeOnly: true),
        barrierLabel: material.MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ));
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final material.ThemeData theme;

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => material.Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = material.BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) bottomSheet = material.Theme(data: theme.copyWith(canvasColor: AppColor.transparent), child: bottomSheet);
    return bottomSheet;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T> route;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final material.MaterialLocalizations localizations = material.MaterialLocalizations.of(context);
    String routeLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        routeLabel = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        routeLabel = localizations.dialogLabel;
        break;
    }

    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () => Navigator.pop(context),
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          // Disable the initial animation when accessible navigation is on so
          // that the semantics are added to the tree at the correct time.
          final double animationValue = mediaQuery.accessibleNavigation ? 1.0 : widget.route.animation.value;
          return Semantics(
            scopesRoute: true,
            namesRoute: true,
            label: routeLabel,
            explicitChildNodes: true,
            child: ClipRect(
              child: CustomSingleChildLayout(
                delegate: _ModalBottomSheetLayout(animationValue),
                child: material.BottomSheet(
                  animationController: widget.route._animationController,
                  onClosing: () => Navigator.pop(context),
                  builder: widget.route.builder,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress);

  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
