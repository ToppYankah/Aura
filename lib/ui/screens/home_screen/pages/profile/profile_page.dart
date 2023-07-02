import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends HomePageItem {
  const ProfilePage({super.key, required super.onPagePop});

  ImageProvider _getUserProfileImage() {
    if (AuthService.user?.photoURL != null) {
      return NetworkImage(AuthService.user!.photoURL!);
    }

    return AppImages.background;
  }

  void _handleLogout(BuildContext context) {
    PromptUtil.show(
      context,
      PromptMessage(
        title: "Logout",
        okayText: "Continue",
        message: "Do you want to proceed logging out?",
        onOk: () async {
          await CommonUtils.callLoader(
            context,
            AuthService.signOut,
            message: "Logging out please wait...",
          );

          onPagePop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ThemeBuilder(builder: (theme, isDark) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(title: "User Profile", onBack: onPagePop),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30)
                          .copyWith(bottom: 40),
                      child: Center(
                        child: Wrap(
                          spacing: 20,
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.cardBackground,
                              backgroundImage: _getUserProfileImage(),
                            ),
                            Column(
                              children: [
                                Text(
                                  AuthService.user?.displayName ??
                                      "[Your Username]",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: theme.paragraphDeep,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  AuthService.user?.email ??
                                      "[Your Email Address]",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.paragraph,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SectionCard(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  isDark ? Colors.white10 : Colors.black12,
                              child: Icon(Iconsax.star,
                                  color: theme.heading, size: 18),
                            ),
                            title: const Text(
                              "Favorite Locations",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3,
                                color: theme.heading, size: 18),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  isDark ? Colors.white10 : Colors.black12,
                              child: Icon(Iconsax.location4,
                                  color: theme.heading, size: 18),
                            ),
                            title: const Text(
                              "Change Location",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3,
                                color: theme.heading, size: 18),
                          ),
                        ],
                      ),
                    ),
                    SectionCard(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  isDark ? Colors.white10 : Colors.black12,
                              child: Icon(Iconsax.edit_24,
                                  color: theme.heading, size: 18),
                            ),
                            title: const Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3,
                                color: theme.heading, size: 18),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  isDark ? Colors.white10 : Colors.black12,
                              child: Icon(Iconsax.lock,
                                  color: theme.heading, size: 18),
                            ),
                            title: const Text(
                              "Change Password",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3,
                                color: theme.heading, size: 18),
                          ),
                        ],
                      ),
                    ),
                    SectionCard(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => _handleLogout(context),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFFF6A5F)
                                  .withOpacity(isDark ? 0.3 : 0.3),
                              child: Icon(Iconsax.trash,
                                  color: theme.heading, size: 18),
                            ),
                            title: const Text(
                              "Delete Account",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3,
                                color: theme.heading, size: 18),
                          ),
                          ListTile(
                            onTap: () => _handleLogout(context),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFFF6A5F)
                                  .withOpacity(isDark ? 0.3 : 0.3),
                              child: Icon(Iconsax.logout_1,
                                  color: theme.heading, size: 18),
                            ),
                            title: const Text(
                              "Logout",
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3,
                                color: theme.heading, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
