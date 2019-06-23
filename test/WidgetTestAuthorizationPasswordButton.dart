import 'package:eps_open_api_reference_app/widget/WidgetScreenAuthorizationPassword.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'WidgetTest.dart';

class TestWidgetAuthorizationPasswordButton implements WidgetTest {
  @override
  String name() {
    return "Authorization password: Button";
  }

  @override
  Widget widget() {
    return WidgetScreenAuthorizationPassword();
  }

  @override
  Future<void> test(WidgetTester tester) async {
    final button = find.byType(ButtonStadium);

    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(button, findsOneWidget);
  }
}
