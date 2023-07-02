import 'package:aura/providers/settings/settings_provider.dart';
import 'package:aura/providers/theme_provider.dart';
import 'package:aura/providers/countries_provider.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/providers/parameters_provider.dart';
import 'package:flutter/material.dart';
import 'package:aura/network/api.dart';
import 'package:provider/provider.dart';
import 'package:aura/network/requester.dart';
import 'package:aura/helpers/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBase extends StatefulWidget {
  const AppBase({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // FlutterNativeSplash.remove();
          Requester requester = Requester();
          ApiCollection apiCollection = ApiCollection(requester: requester);

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider(
                  preferences: snapshot.data!,
                  apiCollection: apiCollection,
                ),
              ),
              ChangeNotifierProvider<LocationProvider>(
                create: (context) => LocationProvider(
                  preferences: snapshot.data!,
                  apiCollection: apiCollection,
                ),
              ),
              ChangeNotifierProvider<CountriesProvider>(
                create: (context) => CountriesProvider(
                  preferences: snapshot.data!,
                  apiCollection: apiCollection,
                ),
              ),
              ChangeNotifierProvider<MeasurementsProvider>(
                create: (context) => MeasurementsProvider(
                  preferences: snapshot.data!,
                  apiCollection: apiCollection,
                ),
              ),
              ChangeNotifierProvider<ParametersProvider>(
                create: (context) => ParametersProvider(
                  preferences: snapshot.data!,
                  apiCollection: apiCollection,
                ),
              ),
              ChangeNotifierProvider<SettingsProvider>(
                create: (context) => SettingsProvider(
                  preferences: snapshot.data!,
                  apiCollection: apiCollection,
                ),
              ),
            ],
            child: widget.child,
          );
        }

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ErrorPage(),
        );
      },
    );
  }
}
