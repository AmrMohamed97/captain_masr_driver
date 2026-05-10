import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/imports/imports.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/notifications/notification_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //! Service Locator
  initServiceLocator();

  //! Cache
  await sl<Cache>().init();

  //! Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  //! Firebase Initialization
  try {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
} catch (e) {
 if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized');
    } else {
      rethrow;
    }
}

  //! Notifications Initialization
  try {
    await Future.wait([
      NotificationHandler.init(),
      LocalNotificationService.init(),
    ]);
  } catch (e) {
    debugPrint('Error initializing notifications: $e');
  }

  //! Run App
  runApp(
    BlocProvider(
      create: (context) => GlobalCubit()..init(),
      child: const CaptainMasrDriver(),
    ),
  );
}
