import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetTitleTextImage {
  static Widget build(String title, String text, String imageSvgAssetPath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 10.0),
          child: Text(
            title,
            style: AppTextStyle.getTextHeader3(color: Colors.white),
            textAlign: TextAlign.start,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.getText1(color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: SvgPicture.asset(
                imageSvgAssetPath,
                semanticsLabel: imageSvgAssetPath,
                color: Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }
}
