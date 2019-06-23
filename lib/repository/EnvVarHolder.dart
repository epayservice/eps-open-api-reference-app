
import 'dart:io';


class EnvVarHolder {
  Map<String, String> env = <String, String>{};
  static EnvVarHolder _singleton;

  factory EnvVarHolder({Map<String, String> env}) {
    if (_singleton == null) {
       final envOs = Map<String, String>();
       envOs.addAll(Platform.environment);
      _singleton = EnvVarHolder._internal(env: envOs);
    }
    return _singleton;
  }

  EnvVarHolder._internal({Map<String, String> env})
      : env = env ?? <String, String>{};
}


