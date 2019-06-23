import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationPassword.dart';
import 'package:eps_open_api_reference_app/bloc/BlocScreenAuthorizationPin.dart';
import 'package:eps_open_api_reference_app/utils/AppAssetPath.dart';
import 'package:eps_open_api_reference_app/utils/AppRoute.dart';
import 'package:eps_open_api_reference_app/utils/AppSnackBar.dart';
import 'package:eps_open_api_reference_app/utils/Errors.dart';
import 'package:eps_open_api_reference_app/widget/WidgetScreen.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/PlatformPageRoute.dart';
import 'package:eps_open_api_reference_app/widget/ui/TextField.dart';
import 'package:eps_open_api_reference_app/widget/ui/WidgetTitleTextImage.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';

import 'WidgetScreenAuthorizationPin.dart';

class WidgetScreenAuthorizationPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetScreenAuthorizationPasswordState();
  }
}

class _WidgetScreenAuthorizationPasswordState extends State<WidgetScreenAuthorizationPassword> {
  final Bloc<BlocStateAuthPW> bloc;
  final FocusNode focusNodeEmail;
  final FocusNode focusNodePassword;

  _WidgetScreenAuthorizationPasswordState()
      : bloc = BlocStorage.storage.getOrCreate<BlocStateAuthPW>(BlocStateAuthPW()),
        focusNodeEmail = new FocusNode(),
        focusNodePassword = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    BlocStorage.storage.destroy(bloc);
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: BlocWidgetObserver(
          bloc: bloc,
          onBuild: (context, state, bloc1) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _onBuildText(state),
                _onBuildEmail(state),
                _onBuildPassword(state),
                _onBuildButton(state),
              ],
            );
          },
          onEvent: _onEvent,
          onError: _onError,
        ),
      ),
    );
  }

  Widget _onBuildText(BlocStateAuthPW state) {
    if (state.useCase == UseCase.emailValidate) {
      return WidgetTitleTextImage.build(
        "Enter email",
        "Please, enter an email for future safety register or login",
        AppAssetPath.getLock(),
      );
    } else if (state.useCase == UseCase.login) {
      return WidgetTitleTextImage.build(
        "Entrance to App",
        "Please, enter a password for login",
        AppAssetPath.getLock(),
      );
    } else if (state.useCase == UseCase.register) {
      return WidgetTitleTextImage.build(
        "Setup Password",
        "Please, enter a password for future safety register",
        AppAssetPath.getLock(),
      );
    } else {
      return Container();
    }
  }

  Widget _onBuildEmail(BlocStateAuthPW state) {
    return Container(
        margin: EdgeInsets.only(top: 30.0),
        child: TextField1(
          focusNode: focusNodeEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: (bloc.state.useCase == UseCase.emailValidate) ? TextInputAction.done : TextInputAction.next,
          labelText: "Email",
          errorText: state.emailError,
          onChanged: _onEmailChanged,
          onSubmitted: (string) {
            focusNodeEmail.unfocus();
            FocusScope.of(context).requestFocus(focusNodePassword);
          },
        ));
  }

  Widget _onBuildPassword(BlocStateAuthPW state) {
    if (state.useCase == UseCase.emailValidate) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(top: 15.0),
        child: TextField1(
          focusNode: focusNodePassword,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          labelText: "Password",
          errorText: state.passwordError,
          obscureText: true,
          onChanged: _onPasswordChanged,
          onSubmitted: (string) {
            focusNodePassword.unfocus();
          },
        ),
      );
    }
  }

  Widget _onBuildButton(BlocStateAuthPW state) {
    Widget widget = ButtonStadium(
      onPressed: _onPressedButtonNext,
      progressIndicatorEnabled: state.isLoading,
      text: (state.useCase == UseCase.emailValidate)
          ? "Continue"
          : (state.useCase == UseCase.register) ? "Register" : (state.useCase == UseCase.login) ? "Login" : "Continue",
      stretchHorizontally: true,
    );

    if (widget != null) {
      return Container(margin: EdgeInsets.only(top: 30.0), child: widget);
    } else {
      return Container();
    }
  }

  void _onEmailChanged(String string) {
    bloc.enqueueAction(BlocActionEmailChanged(string));
  }

  void _onPasswordChanged(String string) {
    bloc.enqueueAction(BlocActionPasswordChanged(string));
  }

  void _onPressedButtonNext() {
    focusNodeEmail.unfocus();
    focusNodePassword.unfocus();
    bloc.enqueueAction(BlocActionOnPressButtonNext());
  }

  void _onEvent(BuildContext context, BlocEvent event, Bloc<BlocState> bloc) {
    if (event is BlocEventGoToSetupPin) {
      Navigator.pushReplacement(
        context,
        PlatformPageRoute.build(
          builder: (context) => WidgetScreenAuthorizationPin(
              useCase: UseCasePin.setup,
              onSuccessCallback: () {
                Navigator.of(context).pushReplacementNamed(AppRoute.screen_authorization_providers);
              }),
        ),
      );
    }
  }

  void _onError(BuildContext context, Object error, Bloc<BlocState> bloc) {
    if (error is ErrorString) {
      final snackBar = AppSnackBar.get(text: error.text);
      material.Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
