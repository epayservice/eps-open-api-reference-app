import 'package:flutter_bloc_architecture/flutter_bloc_architecture.dart';
import 'package:test/test.dart' as TEST;

//import 'UnitTestAuthorizationPassword.dart';

abstract class UnitTest {
  String name();

  Future<void> test();

  void run() async {
    TEST.test("Unit Test: " + name(), () {
      test();
    });
  }
}

void main() {
  BlocStorage.initialize();

//  UnitTestAuthorizationPassword().run();
}
