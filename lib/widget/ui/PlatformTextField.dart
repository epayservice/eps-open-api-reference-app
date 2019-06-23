import 'package:eps_open_api_reference_app/widget/ui/PlatformSelector.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformStatelessWidget.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformWidgetBuilder.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TextFieldData {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final int maxLength;
  final bool maxLengthEnforced;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final String labelText;
  final TextStyle labelStyle;
  final String placeholderText;
  final TextStyle placeholderStyle;
  final String errorText;
  final TextStyle errorStyle;
  final EdgeInsetsGeometry padding;

  TextFieldData({
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
    this.maxLines,
    this.maxLength,
    this.maxLengthEnforced,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.labelText,
    this.labelStyle,
    this.placeholderText,
    this.placeholderStyle,
    this.errorText,
    this.errorStyle,
    this.padding,
  });
}

class MaterialTextFieldData {
  final material.InputDecoration decoration;
  final bool enableInteractiveSelection;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback onTap;
  final material.InputCounterWidgetBuilder buildCounter;

  MaterialTextFieldData({
    this.decoration = const material.InputDecoration(),
    this.enableInteractiveSelection,
    this.dragStartBehavior = DragStartBehavior.down,
    this.onTap,
    this.buildCounter,
  });
}

class CupertinoTextFieldData {
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final String placeholder;
  final Widget prefix;
  final cupertino.OverlayVisibilityMode prefixMode;
  final Widget suffix;
  final cupertino.OverlayVisibilityMode suffixMode;
  final cupertino.OverlayVisibilityMode clearButtonMode;
  final EdgeInsets labelPadding;

  CupertinoTextFieldData({
    this.decoration,
    this.padding,
    this.placeholder,
    this.prefix,
    this.prefixMode = cupertino.OverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = cupertino.OverlayVisibilityMode.always,
    this.clearButtonMode = cupertino.OverlayVisibilityMode.never,
    this.labelPadding,
  });
}

class PlatformTextField extends PlatformStatelessWidget {
  final PlatformWidgetBuilder<TextFieldData> builder;
  final PlatformWidgetBuilder<MaterialTextFieldData> materialBuilder;
  final PlatformWidgetBuilder<CupertinoTextFieldData> cupertinoBuilder;

  PlatformTextField({
    Key key,
    PlatformSelector platform,
    this.builder,
    this.materialBuilder,
    this.cupertinoBuilder,
  }) : super(
          key: key,
          platform: platform,
        );

  @override
  Widget onBuildAndroidWidget(BuildContext context) {
    TextFieldData data;
    if (builder != null) {
      data = builder(context);
    }
    if (data == null) {
      data = TextFieldData();
    }

    MaterialTextFieldData materialData;
    if (materialBuilder != null) {
      materialData = materialBuilder(context);
    }
    if (materialData == null) {
      materialData = MaterialTextFieldData();
    }

    final material.InputDecoration decoration = materialData.decoration.copyWith(
      labelText: materialData.decoration.labelText ?? data.labelText,
      labelStyle: materialData.decoration.labelStyle ?? data.labelStyle,
      errorText: materialData.decoration.errorText ?? data.errorText,
      errorStyle: materialData.decoration.errorStyle ?? data.errorStyle,
      contentPadding: data.padding ?? null,
    );

    return material.TextField(
      controller: data.controller,
      focusNode: data.focusNode,
      keyboardType: data.keyboardType,
      textInputAction: data.textInputAction,
      textCapitalization: data.textCapitalization ?? TextCapitalization.none,
      style: data.textStyle,
      textAlign: data.textAlign ?? TextAlign.start,
      textDirection: data.textDirection,
      autofocus: data.autofocus ?? true,
      obscureText: data.obscureText ?? false,
      autocorrect: data.autocorrect ?? true,
      maxLines: data.maxLines,
      maxLength: data.maxLength,
      maxLengthEnforced: data.maxLengthEnforced ?? true,
      onChanged: data.onChanged,
      onEditingComplete: data.onEditingComplete,
      onSubmitted: data.onSubmitted,
      inputFormatters: data.inputFormatters,
      enabled: data.enabled,
      cursorWidth: data.cursorWidth ?? 2.0,
      cursorRadius: data.cursorRadius,
      cursorColor: data.cursorColor,
      keyboardAppearance: data.keyboardAppearance,
      scrollPadding: data.scrollPadding ?? const EdgeInsets.all(20.0),
      decoration: decoration,
      dragStartBehavior: materialData.dragStartBehavior,
      enableInteractiveSelection: materialData.enableInteractiveSelection,
      onTap: materialData.onTap,
      buildCounter: materialData.buildCounter,
    );
  }

  @override
  Widget onBuildIOSWidget(BuildContext context) {
    TextFieldData data;
    if (builder != null) {
      data = builder(context);
    }
    if (data == null) {
      data = TextFieldData();
    }

    CupertinoTextFieldData cupertinoData;
    if (cupertinoBuilder != null) {
      cupertinoData = cupertinoBuilder(context);
    }
    if (cupertinoData == null) {
      cupertinoData = CupertinoTextFieldData();
    }

    Widget widget = cupertino.CupertinoTextField(
      controller: data.controller,
      focusNode: data.focusNode,
      keyboardType: data.keyboardType,
      textInputAction: data.textInputAction,
      textCapitalization: data.textCapitalization ?? TextCapitalization.none,
      style: data.textStyle,
      textAlign: data.textAlign ?? TextAlign.start,
      autofocus: data.autofocus ?? true,
      obscureText: data.obscureText ?? false,
      autocorrect: data.autocorrect ?? true,
      maxLines: data.maxLines,
      maxLength: data.maxLength,
      maxLengthEnforced: data.maxLengthEnforced ?? true,
      onChanged: data.onChanged,
      onEditingComplete: data.onEditingComplete,
      onSubmitted: data.onSubmitted,
      inputFormatters: data.inputFormatters,
      enabled: data.enabled,
      cursorWidth: data.cursorWidth ?? 2.0,
      cursorRadius: data.cursorRadius,
      cursorColor: data.cursorColor,
      keyboardAppearance: data.keyboardAppearance,
      scrollPadding: data.scrollPadding ?? const EdgeInsets.all(20.0),
      decoration: cupertinoData.decoration,
      padding: cupertinoData.padding ?? (data.padding ?? EdgeInsets.all(6.0)),
      placeholder: cupertinoData.placeholder ?? data.placeholderText,
      prefix: cupertinoData.prefix,
      prefixMode: cupertinoData.prefixMode,
      suffix: cupertinoData.suffix,
      suffixMode: cupertinoData.suffixMode,
      clearButtonMode: cupertinoData.clearButtonMode,
    );

    if (data.labelText != null || data.errorText != null) {
      widget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (data.labelText != null || data.errorText != null)
            Padding(
              padding: cupertinoData.labelPadding ?? EdgeInsets.only(left: 6.0, bottom: 5.0),
              child: Text(
                data.errorText ?? data.labelText,
                style: (data.errorText == null)
                    ? data.labelStyle
                    : (data.errorStyle ??
                        TextStyle(
                          color: cupertino.CupertinoColors.destructiveRed,
                          fontStyle: cupertino.FontStyle.normal,
                        )),
                textAlign: TextAlign.start,
              ),
            ),
          widget,
          //          if (data.errorText != null)
          //            Padding(
          //              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.0),
          //              child: Text(
          //                data.errorText,
          //                style: data.errorStyle ??
          //                    TextStyle(
          //                      color: cupertino.CupertinoColors.destructiveRed,
          //                      fontStyle: cupertino.FontStyle.normal,
          //                    ),
          //                textAlign: TextAlign.start,
          //              ),
          //            ),
        ],
      );
    }

    return widget;
  }
}
