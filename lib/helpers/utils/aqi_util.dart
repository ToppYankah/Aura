import 'package:aura/helpers/utils/pollutant_util.dart';
import 'package:aura/network/api/measurements/models/latest_measurement_data.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_info/pollutant_card_cell.dart';
import 'package:flutter/material.dart';

enum AQIStatusType {
  good,
  moderate,
  unhealthySFG,
  unhealthy,
  veryUnhealthy,
  hazardous
}

class AQIDetails {
  final int value;
  final AQIStatus status;

  const AQIDetails({required this.value, required this.status});
}

class AQIStatus {
  final String name;
  final Range range;
  final Color color;
  final String message;
  final AssetImage icon;
  final AQIStatusType type;
  final Map<String, String> healthTip;

  const AQIStatus({
    required this.type,
    required this.icon,
    required this.name,
    required this.range,
    required this.color,
    required this.message,
    required this.healthTip,
  });
}

class Range {
  final double max;
  final double min;

  const Range({required this.max, required this.min});
}

class AQIUtil {
  AQIUtil._();

  static AQIDetails getAQIDetails({
    required double concentration,
    required PollutantBreakpoint breakpoint,
  }) {
    double breakpointDifference = breakpoint.max - breakpoint.min;
    double indexDifference = breakpoint.aqiMax - breakpoint.aqiMin;
    double concentrationMinDifference = concentration - breakpoint.min;

    int aqiValue = (((indexDifference / breakpointDifference) *
                concentrationMinDifference) +
            breakpoint.aqiMin)
        .round();

    return AQIDetails(value: aqiValue, status: _getAQIStatus(aqiValue));
  }

  static AQIDetails getAQIValue(double concentration) {
    final PollutantBreakpoint breakpoint =
        PollutantUtils.findConcentrationCategory(
            key: "pm25", concentration: concentration);

    final AQIDetails aqiDetails = AQIUtil.getAQIDetails(
      breakpoint: breakpoint,
      concentration: concentration,
    );

    return aqiDetails;
  }

  static AQIStatus _getAQIStatus(int value) {
    final AQIStatus output = statuses.singleWhere(
      (element) => element.range.min <= value && element.range.max >= value,
      orElse: () => statuses.last,
    );
    
    return output;
  }

  static PollutantConcentrationRange getPollutantConcentrationRangeDetail(
      BuildContext context,
      {required SimpleMeasurementData parameter}) {
    PollutantRangeDetail? pollutantRange =
        PollutantUtils.pollutantBreakpoints[parameter.parameter];
    PollutantBreakpoint? breakpoint =
        pollutantRange?.getCategory(parameter.value!);

    if (breakpoint == null) {
      return PollutantConcentrationRange(color: Colors.white, ratio: 0);
    }

    return PollutantConcentrationRange(
      color: pollutantRange?.getColor(breakpoint) ?? Colors.white,
      ratio: pollutantRange?.getRatio(parameter.value ?? 0) ?? 0,
    );
  }

  static List<AQIStatus> statuses = const [
    AQIStatus(
      name: "Good",
      type: AQIStatusType.good,
      icon: AppImages.goodRange,
      color: AppColors.goodRange,
      range: Range(min: 0, max: 50),
      message:
          "Air quality is considered satisfactory, and air pollution poses little or no risk.",
      healthTip: {
        "For Everyone":
            "It's a perfect day to get active outdoors and make the most of the beautiful weather!⛅️",
      },
    ),
    AQIStatus(
      name: "Moderate",
      type: AQIStatusType.moderate,
      icon: AppImages.moderateRange,
      range: Range(min: 51, max: 100),
      color: AppColors.moderateRange,
      message:
          "Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.",
      healthTip: {
        "Unusually Sensitive People":
            "Consider making outdoor activities shorter and less intense. Watch for symptoms such as coughing or shortness of breath. These are signs to take it easier.",
        "For Everyone Else": "It’s a good day to be active outside.",
      },
    ),
    AQIStatus(
      name: "Unhealthy for Sensitive Groups",
      type: AQIStatusType.unhealthySFG,
      icon: AppImages.unhealthFSGRange,
      range: Range(min: 101, max: 150),
      color: AppColors.unhealthyFCGRange,
      message:
          "Members of sensitive groups may experience health effects. The general public is not likely to be affected.",
      healthTip: {
        "Sensitive Groups":
            "Make outdoor activities shorter and less intense. It’s OK to be active outdoors, but take more breaks. Watch for symptoms such as coughing or shortness of breath.",
        "People with Asthma":
            "Follow your asthma action plan and keep quick relief medicine handy.",
        "People with Heart Disease":
            "Symptoms such as palpitations, shortness of breath, or unusual fatigue may indicate a serious problem. If you have any of these, contact your health care provider.",
      },
    ),
    AQIStatus(
      name: "Unhealthy",
      type: AQIStatusType.unhealthy,
      icon: AppImages.unhealthyRange,
      range: Range(min: 151, max: 200),
      color: AppColors.unhealthyRange,
      message:
          "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects.",
      healthTip: {
        "Sensitive Groups":
            "Avoid long or intense outdoor activities. Consider rescheduling or moving activities indoors.",
        "For Everyone Else":
            "Reduce long or intense activities. Take more breaks during outdoor activities.",
      },
    ),
    AQIStatus(
      name: "Very Unhealthy",
      type: AQIStatusType.veryUnhealthy,
      icon: AppImages.veryUnhealthyRange,
      range: Range(min: 201, max: 300),
      color: AppColors.veryUnhealthyRange,
      message:
          "Health warnings of emergency conditions. The entire population is more likely to be affected.",
      healthTip: {
        "Sensitive Groups":
            "Avoid all physical activity outdoors. Reschedule to a time when air quality is better or move activities indoors.",
        "For Everyone Else":
            "Avoid long or intense activities. Consider rescheduling or moving activities indoors.",
      },
    ),
    AQIStatus(
      name: "Hazardous",
      type: AQIStatusType.hazardous,
      icon: AppImages.hazardousRange,
      range: Range(min: 301, max: 500),
      color: AppColors.hazardousRange,
      message:
          "Health alert: everyone may experience more serious health effects.",
      healthTip: {
        "Sensitive Groups":
            "Remain indoors and keep activity levels low. Follow tips for keeping particle levels low indoors.",
        "For Everyone": "Avoid all physical activity outdoors.",
      },
    ),
  ];
}
