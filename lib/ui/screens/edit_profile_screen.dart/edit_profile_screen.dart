// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/screens/edit_profile_screen.dart/data/avatars.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final ValueNotifier<int> _selectedAvatar = ValueNotifier<int>(-1);
  final ValueNotifier<bool> _readyChecker = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _emailController =
        TextEditingController(text: AuthService.user?.email ?? "");
    _nameController =
        TextEditingController(text: AuthService.user?.displayName ?? "");

    _nameController.addListener(_handleCheckReady);
  }

  void _handleSubmit() async {
    String? photoUrl = switch (_selectedAvatar.value) {
      > -1 => await CommonUtils.callLoader<String>(
          context,
          () => FirebaseStorage.instance
              .refFromURL(
                ProfileEditData.avatars.elementAt(_selectedAvatar.value).url,
              )
              .getDownloadURL(),
        ),
      int() => null,
    };

    String? name;
    if (_nameController.text != AuthService.user?.displayName) {
      name = _nameController.text;
    }

    final (String?, bool)? response =
        await CommonUtils.callLoader<(String?, bool)>(
      context,
      message: "Updating profile...",
      () => AuthService.completeProfile(username: name, photoUrl: photoUrl),
    );

    if (response != null) {
      if (response.$2) {
        Navigation.openHomeScreen(
          context,
          const NavigationParams(
            replace: true,
            argument: HomeScreenPage.profile,
          ),
        );
        PromptUtil.show(
          context,
          const PromptMessage(
            type: PromptType.success,
            title: "Update Successful",
            message: "Your profile has been updated successfully.",
          ),
        );

        return;
      }

      PromptUtil.show(
        context,
        PromptMessage(
          message: response.$1!,
          title: "Update Failed",
          type: PromptType.error,
        ),
      );
    }
  }

  void _handleCheckReady() {
    _readyChecker.value = (_nameController.text.isNotEmpty &&
            _nameController.text != AuthService.user?.displayName) ||
        _selectedAvatar.value != -1;
  }

  void _handleAvatarSelect(int index) {
    _selectedAvatar.value = index;
    _handleCheckReady();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _selectedAvatar.dispose();
    _readyChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            const SafeArea(bottom: false, child: AppHeader()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      child: Text(
                        "Customize your profile to\nyour satisfaction.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AppTextField(
                      icon: Iconsax.user_edit,
                      controller: _nameController,
                      placeholder: "Choose username",
                    ),
                    AppTextField(
                      disabled: true,
                      icon: Iconsax.sms,
                      controller: _emailController,
                      placeholder: "New email address",
                    ),
                    SectionCard(
                      useHorizontalSpace: false,
                      title: const SectionCardTitle(
                        "Select your avatar",
                        icon: Iconsax.camera,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: size.width * 0.03,
                        ),
                        child: Wrap(
                          runSpacing: 10,
                          spacing: size.width * 0.02,
                          children: [
                            ...ProfileEditData.avatars.map((avatar) {
                              final double radius = size.width * 0.132;
                              final int index =
                                  ProfileEditData.avatars.indexOf(avatar);

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _handleAvatarSelect(index),
                                  borderRadius: BorderRadius.circular(1000),
                                  child: ValueListenableBuilder(
                                      valueListenable: _selectedAvatar,
                                      builder: (context, selectedIndex, _) {
                                        final bool selected =
                                            selectedIndex == index;
                                        return CircleAvatar(
                                          radius: radius,
                                          backgroundColor: selected
                                              ? AppColors.secondary
                                              : Colors.transparent,
                                          child: CircleAvatar(
                                            radius: radius * 0.9,
                                            backgroundImage: avatar.image,
                                          ),
                                        );
                                      }),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ValueListenableBuilder(
                valueListenable: _readyChecker,
                builder: (context, ready, _) {
                  return SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppSlideButton(
                        buttonRadius: 30,
                        disabled: !ready,
                        onSubmit: _handleSubmit,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
