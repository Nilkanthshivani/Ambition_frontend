import 'package:ambition_delivery/utils/.env.dart';
import 'package:ambition_delivery/utils/bloc_observer.dart';
import 'package:ambition_delivery/utils/location_service.dart';
import 'package:app_set_id/app_set_id.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'di/dependency_injection.dart';
import 'firebase_options.dart';

SharedPreferences? sharedPreferences;
final _appSetIdPlugin = AppSetId();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  Bloc.observer = const AppBlocObserver();
  sharedPreferences = await SharedPreferences.getInstance();
  await setupDependencies();
  await LocationService.requestPermission();
  // You may set the permission requests to "provisional" which allows the user to choose what type
// of notifications they would like to receive once the user receives a notification.
  await FirebaseMessaging.instance.requestPermission(provisional: true);

// For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    if (kDebugMode) {
      print('APNs token: $apnsToken');
    }
  } else {
    if (kDebugMode) {
      print('APNs token not available');
    }
  }
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('FCM token: $fcmToken');
  }
  initPlatformState();
  runApp(const MyApp());
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
  String identifier;
  try {
    identifier = await _appSetIdPlugin.getIdentifier() ?? "Unknown";
    if (kDebugMode) {
      print('AppSetId: $identifier');
    }
  } on PlatformException {
    identifier = 'Failed to get identifier.';
  }
}
