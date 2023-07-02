import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/app_tutorial.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/tutorial/change_location_tutorial.dart';
import 'package:aura/ui/screens/home_screen/tutorial/home_refresh_tutorial.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final GlobalKey _refreshKey = GlobalKey();
  final GlobalKey _locationKey = GlobalKey();
  final AppTutorial _tutorial = AppTutorial();

  @override
  void initState() {
    super.initState();

    CommonUtils.performPostBuild(context, () {
      _tutorial.initialize([
        TutorialItem(
          key: _refreshKey,
          identifier: "Refresh Button",
          widget: const HomeRefreshTutorial(),
        ),
        TutorialItem(
          key: _locationKey,
          identifier: "Location Change Button",
          widget: const ChangeLocationTutorial(),
        )
      ]);

      _tutorial.showTutorial(
        context,
        allowSkip: false,
        viewChekcker: PreferenceKeys.HOME_SCREEN_TUTORIAL,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (theme, isDark) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
              .copyWith(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "aura.",
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 5,
                children: [
                  Consumer<MeasurementsProvider>(
                    builder: (context, provider, _) {
                      return AppIconButton(
                        radius: 20,
                        key: _refreshKey,
                        icon: Iconsax.refresh,
                        background: theme.background,
                        onTap: provider.isLoading
                            ? null
                            : provider.getLatestMeasurement,
                        iconColor:
                            isDark ? AppColors.secondary : AppColors.primary,
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => Navigation.openManualLocationScreen(context),
                    child: Container(
                      width: 35,
                      height: 35,
                      key: _locationKey,
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: theme.background!,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: SmoothBorderRadius(cornerRadius: 100),
                      ),
                      child: Transform.scale(
                        scaleX: 1.3,
                        child: Consumer<LocationProvider>(
                            builder: (context, provider, _) {
                          return CountryFlag(
                            country: Country.fromCode(
                              provider.selectedLocation?.country ?? "",
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
