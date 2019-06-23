import 'package:eps_open_api_reference_app/bloc/BlocAuthorizationBiometrics.dart';
import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationPin.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppColor.dart';
import 'package:eps_open_api_reference_app/utils/AppSnackBar.dart';
import 'package:eps_open_api_reference_app/utils/AppTextStyle.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonCircle.dart';
import 'package:eps_open_api_reference_app/widget/ui/WidgetTitleTextImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

class WidgetScreenAuthorizationPin extends StatefulWidget {
  VoidCallback _onSuccessCallback;
  final UseCasePin _useCase;

  WidgetScreenAuthorizationPin({UseCasePin useCase, VoidCallback onSuccessCallback})
      : _onSuccessCallback = onSuccessCallback,
        _useCase = useCase;

  @override
  State<StatefulWidget> createState() {
    return _WidgetScreenAuthorizationPinState(this._useCase, this._onSuccessCallback);
  }
}

class _WidgetScreenAuthorizationPinState extends State<StatefulWidget> {
  final Bloc<BlocStateAuthPin> blocPin;
  final Bloc<BlocStateAuthBio> blocBio;
  final UseCasePin _useCase;
  VoidCallback _onSuccessCallback;

  _WidgetScreenAuthorizationPinState(UseCasePin useCase, VoidCallback onSuccessCallback)
      : blocPin = BlocStorage.storage.create<BlocStateAuthPin>(BlocStateAuthPin(useCase: useCase)),
        blocBio = BlocStorage.storage.create<BlocStateAuthBio>(BlocStateAuthBio()),
        _useCase = useCase,
        _onSuccessCallback = onSuccessCallback;

  @override
  void initState() {
    super.initState();
    if (_useCase == UseCasePin.enter || _useCase == UseCasePin.confirmation) {
      Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
        blocBio.enqueueAction(BlocActionBioCheckSettingsAndAuthenticate());
      });
    }
  }

  @override
  void dispose() {
    BlocStorage.storage.destroy(blocPin);
    BlocStorage.storage.destroy(blocBio);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainChild = BlocWidgetObserver(
      bloc: blocBio,
      onBuild: (context, stateBio, blocBio) {
        return BlocWidgetObserver(
          bloc: blocPin,
          onBuild: (context, statePin, blocPin) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _onBuildText(context, statePin),
                _onBuildStars(context, statePin),
                _onBuildKeyboard(context, statePin),
              ],
            );
          },
          onEvent: _onEvent,
          onError: _onError,
        );
      },
      onEvent: _onEvent,
      onError: _onError,
    );

    if (_useCase == UseCasePin.confirmation) {
      return Container(padding: EdgeInsets.symmetric(vertical: 10.0), child: mainChild);
    } else {
      return WidgetScreen(child: mainChild);
    }
  }

  Widget _onBuildText(BuildContext context, BlocStateAuthPin state) {
    Widget child = null;
    if (_useCase == UseCasePin.confirmation) {
      child = Text("Please, confirm the transfer via PIN Code or Touch ID", textAlign: TextAlign.center, style: AppTextStyle.getText1(color: AppColor.white));
    } else {
      child = WidgetTitleTextImage.build(
        "Hello!",
        "Please, " + (state.useCase == UseCasePin.setup ? "setup" : "enter") + " you PIN code using keyboard below",
        AppAssetPath.getKey(),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      margin: EdgeInsets.only(top: 10, bottom: 20.0),
      child: child,
    );
  }

  Widget _onBuildStars(BuildContext context, BlocStateAuthPin state) {
    var list = new List<Widget>();

    for (int i = 0; i < state.pin.length; i++) {
      list.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Text("*", style: AppTextStyle.getTextHeader3(color: AppColor.white)),
      ));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: list,
        ),
      ),
    );
  }

  Widget _onBuildKeyboard(BuildContext context, BlocStateAuthPin state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            onBuildButtonDigit('1'),
            onBuildButtonDigit('2'),
            onBuildButtonDigit('3'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            onBuildButtonDigit('4'),
            onBuildButtonDigit('5'),
            onBuildButtonDigit('6'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            onBuildButtonDigit('7'),
            onBuildButtonDigit('8'),
            onBuildButtonDigit('9'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (state.useCase == UseCasePin.setup) ? onBuildButtonOk() : onBuildButtonFingerprint(),
            onBuildButtonDigit('0'),
            onBuildButtonBackspace(),
          ],
        )
      ],
    );
  }

  Widget onBuildButtonDigit(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 80, minHeight: 80),
        child: ButtonCircle(
          padding: EdgeInsets.all(20.0),
          colorEnabled: true,
          text: text,
          textStyle: AppTextStyle.getTextHeader1(),
          onPressed: () {
            blocPin.enqueueAction(BlocActionAddDigit(text));
          },
        ),
      ),
    );
  }

  Widget onBuildButtonIcon(IconData iconData, VoidCallback onPressedCallback) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 80, minHeight: 80),
        child: ButtonCircle(
          padding: EdgeInsets.all(20.0),
          colorEnabled: false,
          childLeft: Icon(
            iconData,
            size: 48.0,
            color: AppColor.white,
          ),
          onPressed: onPressedCallback,
        ),
      ),
    );
  }

  Widget onBuildButtonBackspace() {
    return onBuildButtonIcon(Icons.backspace, () {
      blocPin.enqueueAction(BlocActionBackspace());
    });
  }

  Widget onBuildButtonFingerprint() {
    return onBuildButtonIcon(Icons.fingerprint, () {
      blocBio.enqueueAction(BlocActionBioAuthenticate());
    });
  }

  Widget onBuildButtonOk() {
    return onBuildButtonIcon(Icons.check, () {
      blocPin.enqueueAction(BlockActionValidate());
    });
  }

  void _onEvent(BuildContext context, BlocEvent event, Bloc<BlocState> bloc) {
    if (event is BlocEventPinAuthorizationSuccessful) {
      _onAuthenticationSuccess();
    } else if (event is BlocEventBioAuthenticationSuccess) {
      _onAuthenticationSuccess();
    }
  }

  void _onError(BuildContext context, Object error, Bloc<BlocState> bloc) {
    if (error is ErrorString) {
      final errorString = error;
      final snackBar = AppSnackBar.get(text: errorString.text);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _onAuthenticationSuccess() {
    this._onSuccessCallback();
  }
}
