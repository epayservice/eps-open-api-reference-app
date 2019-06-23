import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:flutter_test/flutter_test.dart';

import 'WidgetTestAuthorizationPasswordButton.dart';
import 'WidgetTestAuthorizationPasswordEmail.dart';
import 'WidgetTestAuthorizationPasswordPassword.dart';

abstract class WidgetTest {
  String name();

  Widget widget();

  Future<void> test(WidgetTester tester);

  static void run(WidgetTest widgetTest) async {
    testWidgets("Widget Test: " + widgetTest.name(), (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: widgetTest.widget()));
      await widgetTest.test(tester);
    });
  }
}

void main() {
  BlocStorage.initialize();

  WidgetTest.run(TestWidgetAuthorizationPasswordButton());
  WidgetTest.run(TestWidgetAuthorizationPasswordEmail());
  WidgetTest.run(TestWidgetAuthorizationPasswordPassword());
}
