import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:aura/ui/app_base.dart';
import 'package:aura/firebase_options.dart';
import 'package:aura/helpers/navigation.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aura/providers/theme_provider.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      runApp(const AppBase(child: AuraApp()));
    },
    (error, stack) => log(error.toString()),
  );
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.theme,
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      initialRoute: Navigation.initialRoute,
      navigatorKey: Navigation.navigatorKey,
      onGenerateRoute: Navigation.onGenerateRoute,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        var isPassive = data.textScaleFactor > 2.0;

        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: data.textScaleFactor * (isPassive ? 2 : 1),
          ),
          child: child!,
        );
      },
    );
  }
}
