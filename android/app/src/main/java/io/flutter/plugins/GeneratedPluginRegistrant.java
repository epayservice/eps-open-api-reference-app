package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.firebaseauth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin;
import com.flutter_webview_plugin.FlutterWebviewPlugin;
import io.flutter.plugins.localauth.LocalAuthPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    FlutterSecureStoragePlugin.registerWith(registry.registrarFor("com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin"));
    FlutterWebviewPlugin.registerWith(registry.registrarFor("com.flutter_webview_plugin.FlutterWebviewPlugin"));
    LocalAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.localauth.LocalAuthPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
