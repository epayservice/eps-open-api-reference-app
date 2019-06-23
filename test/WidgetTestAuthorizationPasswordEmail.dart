import 'package:eps_open_api_reference_app/widget/WidgetScreenAuthorizationPassword.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'WidgetTest.dart';

class TestWidgetAuthorizationPasswordEmail implements WidgetTest {
  @override
  String name() {
    return "Authorization password: Email";
  }

  @override
  Widget widget() {
    return WidgetScreenAuthorizationPassword();
  }

  @override
  Future<void> test(WidgetTester tester) async {
    expect(find.widgetWithText(TextField1, "Email не может быть пустым"), findsNothing);
    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsNothing);

    var email = find.byType(TextField1);
    expect(email, findsWidgets);

    final button = find.byType(ButtonStadium);
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Email не может быть пустым"), findsOneWidget);

    await tester.enterText(email, "email");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, "@");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, ".");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, ".com");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, "email@");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, "email@domain");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, "email@domain.");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);

    await tester.enterText(email, "emaildomain.com");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsOneWidget);
  }
}
