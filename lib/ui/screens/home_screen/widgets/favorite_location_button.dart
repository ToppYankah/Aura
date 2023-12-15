import 'package:aura/helpers/utils/app_tutorial.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/services/firebase/database/database_service.dart';
import 'package:aura/services/firebase/database/models/favorite_location.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/tutorial/favorite_location_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FavoriteLocationButton extends StatefulWidget {
  const FavoriteLocationButton({super.key});

  @override
  State<FavoriteLocationButton> createState() => _FavoriteLocationButtonState();
}

class _FavoriteLocationButtonState extends State<FavoriteLocationButton> {
  final GlobalKey _favoriteKey = GlobalKey();
  final AppTutorial _tutorial = AppTutorial();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    CommonUtils.performPostBuild(context, () {
      _tutorial.initialize([
        TutorialItem(
          key: _favoriteKey,
          identifier: "Favorite Button",
          widget: const FavoriteLocationTutorial(),
        ),
      ]);

      _tutorial.showTutorial(
        context,
        allowSkip: false,
        viewChekcker: PreferenceKeys.HOME_SCREEN_TUTORIAL,
      );
    });
  }

  void _handleAddFavorite() async {
    _isLoading.value = true;
    final locationData =
        Provider.of<LocationProvider>(context, listen: false).selectedLocation;

    final response = await DatabaseService.findFavoriteLocationById(
      userEmail: AuthService.user!.email!,
      locationId: locationData!.id!,
    );

    final FavoriteLocation favLocation = FavoriteLocation(
      locationId: locationData.id!,
      country: locationData.country!,
      locationName: locationData.name!,
      userEmail: AuthService.user!.email!,
    );

    if (response == null) {
      print("Adding location to favorites");
      await DatabaseService.addFavoriteLocation(favLocation);
    } else {
      print("Removing location from favorites");
      await DatabaseService.removeFromFavorites(favLocation);
    }

    _isLoading.value = false;
  }

  Future<IconData> _getIcon() async {
    final locationId = Provider.of<LocationProvider>(context, listen: false)
        .selectedLocation!
        .id!;

    final response = await DatabaseService.findFavoriteLocationById(
      userEmail: AuthService.user!.email!,
      locationId: locationId,
    );

    if (response != null) return Iconsax.heart5;

    return Iconsax.heart;
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.hasUser) return const SizedBox();

    return StreamBuilder(
      stream: DatabaseService.favoritesStream(AuthService.user?.email ?? ""),
      builder: (context, snapshot) {
        return ThemeBuilder(
          builder: (theme, isDark) {
            return ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (context, loading, _) {
                return FutureBuilder(
                  future: _getIcon(),
                  builder: (context, snapshot) {
                    return AppIconButton(
                      radius: 20,
                      disabled: loading,
                      key: _favoriteKey,
                      onTap: _handleAddFavorite,
                      background: theme.background,
                      icon: snapshot.data ?? Iconsax.heart,
                      iconColor:
                          isDark ? AppColors.secondary : AppColors.primary,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
