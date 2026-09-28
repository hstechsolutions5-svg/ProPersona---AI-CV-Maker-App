import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options_dev.dart' as dev;
import '../../firebase_options_prod.dart' as prod;
import 'app_environment.dart';
import 'environment_config.dart';

abstract final class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    switch (EnvironmentConfig.environment) {
      case AppEnvironment.production:
        return prod.DefaultFirebaseOptions.currentPlatform;

      case AppEnvironment.staging:
        throw UnsupportedError(
          'Staging Firebase configuration has not been added yet.',
        );

      case AppEnvironment.development:
        return dev.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
