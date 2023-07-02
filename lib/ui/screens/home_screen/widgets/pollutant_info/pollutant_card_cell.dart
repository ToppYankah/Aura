import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/pollutant_util.dart';
import 'package:aura/network/api/measurements/models/latest_measurement_data.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_info/pollutant_details.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class PollutantConcentrationRange {
  final Color color;
  final double ratio;

  PollutantConcentrationRange({required this.color, required this.ratio})
      : assert(ratio >= 0 && ratio <= 1);
}

class PollutantCell extends StatefulWidget {
  final double? width;
  final SimpleMeasurementData data;
  const PollutantCell({super.key, required this.data, this.width});

  @override
  State<PollutantCell> createState() => _PollutantCellState();
}

class _PollutantCellState extends State<PollutantCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PollutantConcentrationRange detail =
        AQIUtil.getPollutantConcentrationRangeDetail(context,
            parameter: widget.data);

    return ThemeBuilder(builder: (theme, isDark) {
      return SizedBox(
        width: widget.width,
        child: InkWell(
          splashColor: AppColors.secondary.withOpacity(isDark ? 0.1 : 0.8),
          highlightColor: AppColors.secondary.withOpacity(isDark ? 0.1 : 0.8),
          borderRadius:
              SmoothBorderRadius(cornerRadius: 25, cornerSmoothing: 0.8),
          onTap: _handleShowPollutantDetails,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: PollutantDetail(
              name: "${widget.data.parameter?.toUpperCase()}",
              animation: _controller,
              average: "${widget.data.value?.toStringAsFixed(1)}",
              color: detail.color,
              ratio: detail.ratio,
            ),
          ),
        ),
      );
    });
  }

  void _handleShowPollutantDetails() {
    final PollutantConcentrationRange detail =
        AQIUtil.getPollutantConcentrationRangeDetail(context,
            parameter: widget.data);

    CommonUtils.showModal(
      context,
      options: const ModalOptions(backgroundDismissible: true),
      child: (closeModal) => ThemeBuilder(builder: (theme, isDark) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              decoration: BoxDecoration(
                color: theme.cardBackground,
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
              ),
              child: PollutantDetail(
                name: "${widget.data.parameter?.toUpperCase()}",
                animation: _controller,
                average: "${widget.data.value?.toStringAsFixed(1)}",
                color: detail.color,
                ratio: detail.ratio,
              ),
            ),
            Text(
              PollutantUtils
                  .pollutantBreakpoints[widget.data.parameter]!.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: theme.paragraphDeep, height: 1.5),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: AppTextButton(
                paddingSpace: 20,
                text: "Read More",
                enableBackground: true,
                icon: EvaIcons.arrowForward,
                iconPosition: IconPosition.after,
                color: isDark ? null : AppColors.primary,
                onTap: () {
                  closeModal();
                  Navigation.openWebView(
                    context,
                    const NavigationParams(
                      argument: ExternalLinks.airPollutionWebsite,
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
