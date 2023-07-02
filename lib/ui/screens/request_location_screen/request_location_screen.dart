// ignore_for_file: use_build_context_synchronously
import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/providers/countries_provider.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_button.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestLocationScreen extends StatefulWidget {
  const RequestLocationScreen({super.key});

  @override
  State<RequestLocationScreen> createState() => _RequestLocationScreenState();
}

class _RequestLocationScreenState extends State<RequestLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Let's Find Your\nLocation",
                        style: theme.styles!.hugeText.copyWith(
                          color: theme.heading,
                          fontFamily: AppFonts.lufgaFont,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "We'll need access to your phone's\nGPS to locate you.",
                      textAlign: TextAlign.center,
                      style: theme.styles!.paragraph.copyWith(
                        color: theme.paragraph,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: isDark ? 0.2 : 0.4,
                        child: const Image(
                          fit: BoxFit.contain,
                          image: AppImages.circles,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: const Offset(0, 8),
                        child: Opacity(
                          opacity: 0.9,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: isDark
                                ? AppColors.primary.withOpacity(0.5)
                                : Colors.transparent,
                            backgroundImage: isDark
                                ? AppImages.locationDark
                                : AppImages.locationLight,
                            child: const Image(
                              image: AppImages.locationIcon,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: MediaQuery.of(context).size.width * 0.12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      text: "Locate Me",
                      onTap: _handleLocateMe,
                      textColor: Colors.white,
                      background: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      text: "Choose Instead",
                      background: theme.border,
                      onTap: () => Navigation.openManualLocationScreen(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _handleLocateMe() async {
    // Request for user location permission
    CommonUtils.requiresGPSPermission(
      context,
      () async {
        PromptMessage? toastMessage;
        final locationProvider =
            Provider.of<LocationProvider>(context, listen: false);

        final countryProvider =
            Provider.of<CountriesProvider>(context, listen: false);

        await CommonUtils.callLoader(
          context,
          () => locationProvider.getUserCurrentLocation(),
          message: "Getting location details",
        );

        await CommonUtils.callLoader(
          context,
          () => countryProvider.getCountryFromLocation(
              locationProvider.selectedLocation?.country),
          message: "Getting location details",
        );

        if (locationProvider.error != null) {
          toastMessage = PromptMessage(
            title: "Failed",
            type: PromptType.error,
            message: locationProvider.error!,
          );
        } else {
          // Save location as reference to Measurements provider
          CommonUtils.saveLocationAsReferenceForMeasurement(context);

          // Navigate to home screen
          Navigation.openHomeScreen(
              context, const NavigationParams(replace: true));
        }

        if (toastMessage != null) {
          PromptUtil.show(context, toastMessage);
        }
      },
    );
  }
}
