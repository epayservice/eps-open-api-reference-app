import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TextField1 extends PlatformTextField {
  TextField1({
    Key key,
    PlatformSelector platform,
    String labelText,
    String errorText,
    ValueChanged<String> onChanged,
    ValueChanged<String> onSubmitted,
    bool obscureText,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    FocusNode focusNode,
    List<TextInputFormatter> inputFormatters,
  }) : super(
          key: key,
          platform: PlatformSelector.autodetect,
          builder: (context) => TextFieldData(
                autocorrect: false,
                textStyle: TextStyle(color: AppColor.white, fontSize: 24, fontWeight: FontWeight.w400, decoration: TextDecoration.none),
                labelText: labelText,
                labelStyle: TextStyle(color: AppColor.white, fontSize: 18, fontWeight: FontWeight.w400, decoration: TextDecoration.none),
                errorText: errorText,
                textAlign: TextAlign.center,
                maxLines: 1,
                obscureText: obscureText,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                inputFormatters: inputFormatters,
                focusNode: focusNode,
                autofocus: false,
              ),
          materialBuilder: (context) => MaterialTextFieldData(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColor.white, width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(3.0), topRight: Radius.circular(3.0)),
                  ),
                  filled: true,
                  fillColor: AppColor.white50,
                  hasFloatingPlaceholder: true,
                  alignLabelWithHint: false,
                  isDense: true,
                  hintMaxLines: 1,
                  errorMaxLines: 5,
                ),
              ),
          cupertinoBuilder: (context) => CupertinoTextFieldData(
                decoration: BoxDecoration(
                  color: AppColor.white50,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                labelPadding: EdgeInsets.only(left: 6.0, bottom: 5.0),
              ),
        );
}

class TextField2 extends PlatformTextField {
  TextField2({
    Key key,
    PlatformSelector platform,
    String labelText,
    String errorText,
    ValueChanged<String> onChanged,
    ValueChanged<String> onSubmitted,
    bool obscureText,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    FocusNode focusNode,
    List<TextInputFormatter> inputFormatters,
  }) : super(
          key: key,
          platform: PlatformSelector.autodetect,
          builder: (context) {
            return TextFieldData(
              textStyle: TextStyle(color: AppColor.blue, fontSize: 24, fontWeight: FontWeight.w400, decoration: TextDecoration.none),
              labelText: labelText,
              labelStyle: TextStyle(color: AppColor.blueOnWhite, fontSize: 18, fontWeight: FontWeight.w400, decoration: TextDecoration.none),
              errorText: errorText,
              textAlign: TextAlign.start,
              maxLines: 1,
              obscureText: obscureText,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              focusNode: focusNode,
              autofocus: false,
            );
          },
          materialBuilder: (context) {
            return MaterialTextFieldData(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.blueOnWhite, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(3.0), topRight: Radius.circular(3.0)),
                ),
                filled: true,
                fillColor: AppColor.grey,
                hasFloatingPlaceholder: true,
                alignLabelWithHint: false,
                isDense: true,
                hintMaxLines: 1,
                errorMaxLines: 5,
              ),
            );
          },
          cupertinoBuilder: (context) {
            return CupertinoTextFieldData(
              decoration: BoxDecoration(
                color: AppColor.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              labelPadding: EdgeInsets.only(left: 6.0, bottom: 5.0),
            );
          },
        );
}
