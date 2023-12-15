// ignore_for_file: use_build_context_synchronously
import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends HomePageItem {
  const ProfilePage({super.key});

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
            message: "Logging out, please wait...",
          );

          // onPagePop();
        },
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context) {
    PromptUtil.show(
      context,
      PromptMessage(
        okayText: "Delete",
        title: "Delete Account",
        message:
            "Please note that this account cannot be recovered after it has been deleted. Would you like to proceed to deleting the account?",
        onOk: () async {
          final (bool, String?)? response =
              await CommonUtils.callLoader<(bool, String?)>(
            context,
            AuthService.deleteAccount,
            message: "Deleting your account...",
          );

          if (response != null) {
            // if (response.$1) return onPagePop();

            PromptUtil.show(
              context,
              PromptMessage(
                title: "Something went wrong",
                message: response.$2!,
              ),
            );
          }
          ;
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
            const AppHeader(title: "User Profile", titleOnly: true),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                child: StreamBuilder<User?>(
                    stream: AuthService.userStream,
                    builder: (context, AsyncSnapshot<User?> snapshot) {
                      return Column(
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
                                    radius: 60,
                                    backgroundColor: theme.cardBackground,
                                    backgroundImage: _getUserProfileImage(),
                                  ),
                                  Column(
                                    children: [
                                      if (AuthService.user?.displayName != null)
                                        Text(
                                          AuthService.user!.displayName!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: theme.paragraphDeep,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      if (AuthService.user?.email != null)
                                        Text(
                                          AuthService.user!.email!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: theme.paragraph,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      if (AuthService.user?.phoneNumber != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            AuthService.user!.phoneNumber!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.paragraph,
                                              fontWeight: FontWeight.w500,
                                            ),
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
                                // Favorite Location ---------------------------
                                ListTile(
                                  onTap: () =>
                                      Navigation.openFavoriteLocations(context),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isDark
                                        ? Colors.white10
                                        : Colors.black12,
                                    child: Icon(Iconsax.heart,
                                        color: theme.heading, size: 18),
                                  ),
                                  title: const Text(
                                    "Favorite Locations",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  trailing: Icon(Iconsax.arrow_right_3,
                                      color: theme.heading, size: 18),
                                ),
                                // Edit Profile ---------------------------
                                ListTile(
                                  onTap: () =>
                                      Navigation.openEditProfile(context),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isDark
                                        ? Colors.white10
                                        : Colors.black12,
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

                                // Add Phone Number ---------------------------
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isDark
                                        ? Colors.white10
                                        : Colors.black12,
                                    child: Icon(Iconsax.call,
                                        color: theme.heading, size: 18),
                                  ),
                                  title: Text(
                                    AuthService.userHasPhoneNumber
                                        ? "Change Phone Number"
                                        : "Add Phone Number",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Icon(Iconsax.arrow_right_3,
                                      color: theme.heading, size: 18),
                                  onTap: () =>
                                      Navigation.openPhoneVerification(context),
                                ),

                                // Change Password ---------------------------
                                ListTile(
                                  onTap: () =>
                                      Navigation.openChangePassword(context),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isDark
                                        ? Colors.white10
                                        : Colors.black12,
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
                                // Delete Account ---------------------------
                                ListTile(
                                  onTap: () => _handleDeleteAccount(context),
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

                                // Logout ---------------------------
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
                      );
                    }),
              ),
            )
          ],
        );
      }),
    );
  }
}
