import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'error_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (errordetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errordetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const SoftitoCrashApp());
}

class SoftitoCrashApp extends StatelessWidget {
  const SoftitoCrashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Crashlytics Test')),
        body: Center(child: HataServisi().cokmeTestiButonu()),
      ),
    );
  }
}