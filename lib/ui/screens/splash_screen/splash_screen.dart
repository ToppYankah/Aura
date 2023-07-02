// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/storage_manager.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_svgs.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await CommonUtils.doPrefetchs(context: context);

      Future.delayed(const Duration(seconds: 3), _handleNavigationAfterDelay);
    });
  }

  void _handleNavigationAfterDelay() async {
    final measurementProvider =
        Provider.of<MeasurementsProvider>(context, listen: false);
    log("Users First Time: ${await AppStorageManager.isUserFirstTime}");

    // Navigate to onboarding screen if user is new
    if (await AppStorageManager.isUserFirstTime) {
      Navigation.openOnboardingScreen(
          context, const NavigationParams(replace: true));
    }

    // Navigate to homescreen if there's a measurement
    else if (measurementProvider.hasReference) {
      Navigation.openHomeScreen(context, const NavigationParams(replace: true));
    }

    // Navigate to location request if there's a measurement
    else {
      Navigation.openRequestLocationScreen(
          context, const NavigationParams(replace: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        final SvgPicture logo = SvgPicture.asset(
          isDark ? AppSvgs.logo : AppSvgs.logoLight,
          width: 100,
        );

        return Stack(
          children: [
            Align(alignment: Alignment.center, child: logo),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: AppLoader(),
              ),
            )
          ],
        );
      },
    );
  }
}
