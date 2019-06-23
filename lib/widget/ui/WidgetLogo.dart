import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WidgetLogo extends StatelessWidget {
  final Color _color;

  WidgetLogo({
    Color color,
  }) : _color = color ?? AppColor.blue;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: 45.0,
      width: double.maxFinite,
      child: SvgPicture.asset(
        AppAssetPath.getEpayserviceLogo(),
        semanticsLabel: 'Image: ePayService logo',
        fit: BoxFit.contain,
        color: _color,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
    //    child:
    //    Image.asset(
    //      AppAssetPath.getEpayserviceLogoPng(),
    //      fit: BoxFit.scaleDown,
    //      semanticLabel: "Image: logo",
    //      color: _color,
    //    )
    //    );
  }
}
