// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordModal extends StatefulWidget {
  final VoidCallback onClose;
  const ChangePasswordModal({super.key, required this.onClose});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final ValueNotifier<bool> _readyChecker = ValueNotifier<bool>(false);
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _newPasswordController.addListener(_checkReady);
    _currentPasswordController.addListener(_checkReady);
    _confirmPasswordController.addListener(_checkReady);
  }

  void _checkReady() {
    _readyChecker.value = _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _currentPasswordController.text.isNotEmpty;
  }

  void _handleChangePassword() async {
    final (bool, String?)? response =
        await CommonUtils.callLoader<(bool, String?)>(
      context,
      message: "Loading, please wait...",
      () => AuthService.changePassword(
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
        currentPassword: _currentPasswordController.text,
      ),
      onError: () {
        PromptUtil.show(
          context,
          const PromptMessage(
            type: PromptType.error,
            title: "Something went Wrong",
            message: "Failed to change/update your password. Please try again.",
          ),
        );
      },
    );

    if (response != null) {
      final (success, error) = response;

      if (success) {
        return PromptUtil.show(
          context,
          PromptMessage(
            type: PromptType.success,
            title: "Change Successful",
            onOk: () async => widget.onClose(),
            message: "Your passwword has been changed successfully.",
          ),
        );
      }

      PromptUtil.show(
        context,
        PromptMessage(
          message: error!,
          type: PromptType.error,
          title: "Something went Wrong",
        ),
      );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    _readyChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          AppTextField(
            placeholder: "Current Password",
            type: TextInputType.visiblePassword,
            controller: _currentPasswordController,
            // hint: "Should contain atleast 8 characters",
          ),
          AppTextField(
            controller: _newPasswordController,
            placeholder: "Choose New Password",
            type: TextInputType.visiblePassword,
            hint: "Should contain atleast 8 characters",
          ),
          AppTextField(
            placeholder: "Confirm New Password",
            type: TextInputType.visiblePassword,
            controller: _confirmPasswordController,
            hint: "Ensure this matches new password",
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ValueListenableBuilder(
                valueListenable: _readyChecker,
                builder: (context, ready, _) {
                  return AppSlideButton(
                    buttonRadius: 25,
                    disabled: !ready,
                    onSubmit: _handleChangePassword,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
