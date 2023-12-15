// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/services/firebase/database/database_service.dart';
import 'package:aura/services/firebase/database/models/favorite_location.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteLocationTile extends StatefulWidget {
  final FavoriteLocation data;
  const FavoriteLocationTile({super.key, required this.data});

  @override
  State<FavoriteLocationTile> createState() => _FavoriteLocationTileState();
}

class _FavoriteLocationTileState extends State<FavoriteLocationTile> {
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  void _handleRemove() async {
    _loading.value = true;

    await DatabaseService.removeFromFavorites(widget.data);

    _loading.value = false;
  }

  void _handleSwitchLocation() async {
    final provider = Provider.of<LocationProvider>(context, listen: false);

    final bool? response = await CommonUtils.callLoader<bool>(
      context,
      message: "Switching location...",
      () => provider.switchLocation(widget.data.locationId),
    );

    if (response == null || !response) {
      PromptUtil.show(
        context,
        PromptMessage(
          type: PromptType.error,
          title: "Switch Failure",
          message:
              "Failed to switch to ${widget.data.locationName}. Please try again.",
        ),
      );
    } else {
      PromptUtil.show(
        context,
        PromptMessage(
          type: PromptType.success,
          title: "Switch Successful",
          message:
              "You have successfully switched locations to\n${widget.data.locationName}.",
        ),
      );
    }
  }

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Consumer<LocationProvider>(builder: (context, provider, _) {
        final int currentId = provider.selectedLocation!.id!;
        final bool active = currentId == widget.data.locationId;

        return SectionCard(
          onTap: active ? null : _handleSwitchLocation,
          showInteractiveIndicator: false,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CountryFlag(
                      height: 35,
                      country: Country.fromCode(widget.data.country),
                    ),
                    if (active)
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: theme.background,
                          child: const CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.data.locationName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Ghana",
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.paragraph,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _loading,
                  builder: (context, loading, _) {
                    return AppTextButton(
                      textSize: 13,
                      text: "Remove",
                      disabled: loading,
                      onTap: _handleRemove,
                      enableBackground: true,
                      textWeight: FontWeight.w400,
                      color: Colors.red.shade400,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
