import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformStatelessWidget.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformWidgetBuilder.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class MaterialSpinProgressIndicatorData {
  final Color backgroundColor;
  final Animation<Color> valueColor;
  final double strokeWidth;
  final Color color;

  MaterialSpinProgressIndicatorData({
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth,
    this.color,
  });
}

class SpinProgressIndicator extends PlatformStatelessWidget {
  final PlatformWidgetBuilder<MaterialSpinProgressIndicatorData> materialBuilder;

  SpinProgressIndicator({
    Key key,
    PlatformSelector platform,
    this.materialBuilder,
  }) : super(
          key: key,
          platform: platform,
        );

  @override
  Widget onBuildAndroidWidget(BuildContext context) {
    MaterialSpinProgressIndicatorData materialData;
    if (materialBuilder != null) {
      materialData = materialBuilder(context);
    }
    if (materialData == null) {
      materialData = MaterialSpinProgressIndicatorData();
    }

    Widget widget = FittedBox(
      child: material.CircularProgressIndicator(
        backgroundColor: materialData.backgroundColor,
        valueColor: materialData.valueColor,
        strokeWidth: materialData.strokeWidth ?? 4.0,
      ),
    );

    return widget;
  }

  @override
  Widget onBuildIOSWidget(BuildContext context) {
    return FittedBox(
      child: cupertino.CupertinoActivityIndicator(
        animating: true,
      ),
    );
  }
}
