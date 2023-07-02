import 'package:flutter/material.dart';
import 'package:aura/resources/app_colors.dart';

enum PollutantKey { pm1, pm25, pm10 }

class PollutantBreakpoint {
  final double min;
  final double max;
  final double aqiMin;
  final double aqiMax;

  PollutantBreakpoint({
    required this.min,
    required this.max,
    required this.aqiMax,
    required this.aqiMin,
  });

  bool inRange(double value) => (value >= min) && (value <= max);
}

class PollutantUtils {
  PollutantUtils._();

  static PollutantBreakpoint findConcentrationCategory({
    required String key,
    required double concentration,
  }) {
    return pollutantBreakpoints[key]!.getCategory(concentration);
  }

  static Map<String, PollutantRangeDetail> pollutantBreakpoints = {
    "pm1": PollutantRangeDetail(
      good: PollutantBreakpoint(min: 0, max: 54, aqiMax: 50, aqiMin: 0),
      moderate: PollutantBreakpoint(min: 55, max: 154, aqiMax: 100, aqiMin: 51),
      unhealthyFSG:
          PollutantBreakpoint(min: 155, max: 254, aqiMax: 150, aqiMin: 101),
      unhealthy:
          PollutantBreakpoint(min: 255, max: 354, aqiMax: 200, aqiMin: 151),
      veryUnhealthy:
          PollutantBreakpoint(min: 355, max: 424, aqiMax: 300, aqiMin: 201),
      hazardous:
          PollutantBreakpoint(min: 425, max: 604, aqiMax: 500, aqiMin: 301),
      description:
          "PM1 refers to particles with a diameter of 1 micrometer or smaller, such as fine combustion particles and pollutants, which can easily enter the respiratory system and potentially cause severe health issues due to their extremely small size.",
    ),
    "pm10": PollutantRangeDetail(
      good: PollutantBreakpoint(min: 0, max: 54, aqiMax: 50, aqiMin: 0),
      moderate: PollutantBreakpoint(min: 55, max: 154, aqiMax: 100, aqiMin: 51),
      unhealthyFSG:
          PollutantBreakpoint(min: 155, max: 254, aqiMax: 150, aqiMin: 101),
      unhealthy:
          PollutantBreakpoint(min: 255, max: 354, aqiMax: 200, aqiMin: 151),
      veryUnhealthy:
          PollutantBreakpoint(min: 355, max: 424, aqiMax: 300, aqiMin: 201),
      hazardous:
          PollutantBreakpoint(min: 425, max: 604, aqiMax: 500, aqiMin: 301),
      description:
          "PM10 refers to particles with a diameter of 10 micrometers or smaller, including dust, pollen, and larger smoke particles, which can also be harmful when inhaled but generally do not penetrate as deeply into the lungs as PM2.5 particles.",
    ),
    "pm25": PollutantRangeDetail(
      good: PollutantBreakpoint(min: 0, max: 12, aqiMax: 50, aqiMin: 0),
      moderate:
          PollutantBreakpoint(min: 12.1, max: 35.4, aqiMax: 100, aqiMin: 51),
      unhealthyFSG:
          PollutantBreakpoint(min: 35.5, max: 55.4, aqiMax: 150, aqiMin: 101),
      unhealthy:
          PollutantBreakpoint(min: 55.5, max: 150.4, aqiMax: 200, aqiMin: 151),
      veryUnhealthy:
          PollutantBreakpoint(min: 150.5, max: 250.4, aqiMax: 300, aqiMin: 201),
      hazardous:
          PollutantBreakpoint(min: 250.5, max: 500.4, aqiMax: 500, aqiMin: 301),
      description:
          "PM25 refers to tiny particles, smaller than 2.5 micrometers, found in smoke, haze, and dust that can penetrate deep into the respiratory system and cause health issues when inhaled.",
    ),
    "co": PollutantRangeDetail(
      good: PollutantBreakpoint(min: 0, max: 54, aqiMax: 50, aqiMin: 0),
      moderate: PollutantBreakpoint(min: 55, max: 154, aqiMax: 100, aqiMin: 51),
      unhealthyFSG:
          PollutantBreakpoint(min: 155, max: 254, aqiMax: 150, aqiMin: 101),
      unhealthy:
          PollutantBreakpoint(min: 255, max: 354, aqiMax: 200, aqiMin: 151),
      veryUnhealthy:
          PollutantBreakpoint(min: 355, max: 424, aqiMax: 300, aqiMin: 201),
      hazardous:
          PollutantBreakpoint(min: 425, max: 604, aqiMax: 500, aqiMin: 301),
      description:
          "CO, short for carbon monoxide, is a colorless and odorless gas produced by the incomplete combustion of carbon-based fuels such as gasoline, natural gas, and coal. High levels of CO can be harmful to human health, as it binds to hemoglobin in the bloodstream, reducing its ability to transport oxygen. Symptoms of CO poisoning include headache, dizziness, nausea, and in severe cases, it can lead to unconsciousness or death. It is important to have proper ventilation and avoid exposure to high levels of carbon monoxide.",
    ),
  };
}

class PollutantRangeDetail {
  final String description;
  final PollutantBreakpoint good;
  final PollutantBreakpoint moderate;
  final PollutantBreakpoint unhealthyFSG;
  final PollutantBreakpoint unhealthy;
  final PollutantBreakpoint veryUnhealthy;
  final PollutantBreakpoint hazardous;

  PollutantRangeDetail({
    required this.good,
    required this.moderate,
    required this.unhealthy,
    required this.hazardous,
    required this.description,
    required this.unhealthyFSG,
    required this.veryUnhealthy,
  });

  double getRatio(double value) {
    final double ratio = value / hazardous.max;

    if (ratio <= 1) return ratio;
    return 1;
  }

  PollutantBreakpoint getCategory(double value) {
    if (value >= good.min && value <= good.max) {
      return good;
    }
    if (value >= moderate.min && value <= moderate.max) {
      return moderate;
    }
    if (value >= unhealthy.min && value <= unhealthy.max) {
      return unhealthy;
    }
    if (value >= unhealthyFSG.min && value <= unhealthyFSG.max) {
      return unhealthyFSG;
    }
    if (value >= veryUnhealthy.min && value <= veryUnhealthy.max) {
      return veryUnhealthy;
    }
    if (value >= hazardous.min && value <= hazardous.max) {
      return hazardous;
    }

    return hazardous;
  }

  Color getColor(PollutantBreakpoint breakpoint) {
    if (breakpoint == good) return AppColors.goodRange;
    if (breakpoint == moderate) return AppColors.moderateRange;
    if (breakpoint == unhealthyFSG) return AppColors.unhealthyFCGRange;
    if (breakpoint == unhealthy) return AppColors.unhealthyRange;
    if (breakpoint == veryUnhealthy) return AppColors.veryUnhealthyRange;
    if (breakpoint == hazardous) return AppColors.hazardousRange;

    return Colors.white;
  }
}
