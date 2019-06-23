import 'package:eps_open_api_reference_app/widget/WidgetScreenAuthorizationPassword.dart';
import 'package:eps_open_api_reference_app/widget/ui/ButtonStadium.dart';
import 'package:eps_open_api_reference_app/widget/ui/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'WidgetTest.dart';

class TestWidgetAuthorizationPasswordPassword implements WidgetTest {
  @override
  String name() {
    return "Authorization password: Password";
  }

  @override
  Widget widget() {
    return WidgetScreenAuthorizationPassword();
  }

  @override
  Future<void> test(WidgetTester tester) async {
    var email = find.byType(TextField1);
    final button = find.byType(ButtonStadium);

    await tester.enterText(email, "email@domain.com");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Email не может быть пустым"), findsNothing);
    expect(find.widgetWithText(TextField1, "Это не похоже на email"), findsNothing);

    final textFields = find.byType(TextField1);
    expect(textFields, findsNWidgets(2));

    final password = textFields.at(1);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Пароль не может быть пустым"), findsOneWidget);

    await tester.enterText(password, "abc");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Пароль должен содержать как минимум 6 символов"), findsOneWidget);

    await tester.enterText(password, "abcdef");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Пароль не должен содержать только буквы"), findsOneWidget);

    await tester.enterText(password, "123456");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Пароль не должен содержать только цифры"), findsOneWidget);

    await tester.enterText(password, "abc123");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Пароль должен содержать хотя бы одну заглавную букву"), findsOneWidget);

    await tester.enterText(password, "aBc123");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField1, "Пароль должен содержать хотя бы один символ"), findsOneWidget);
  }
}
