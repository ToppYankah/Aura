import 'package:aura/resources/app_images.dart';
import 'package:flutter/material.dart';

class HealthTipsData {
  static const List<HealthTip> healthTips = [
    HealthTip(
      title: "Practical Tips to Fight Pollution",
      message:
          " Uncover smart and simple ways to minimize air pollution and protect our environment.",
      image: AppImages.atmospherePollution,
    ),
    HealthTip(
      title: "Cut down on single-use plastic products",
      message:
          "Avoid using plastic bags, they take longer to decompose. Use paper bags or basket for your shipping.",
      image: AppImages.plastics,
    ),
    HealthTip(
      title: "Avoid burning garbage",
      message:
          "Burning your household garbage is dangerous to your health and our environment.",
      image: AppImages.garbageIcon,
    ),
    HealthTip(
      title: "Avoid idling your car engine in traffic",
      message:
          "Vehicles produce particularly unhealthy exhaust. Switch off your engine while in traffic.",
      image: AppImages.engineIcon,
    ),
    HealthTip(
      title: "Use public transport",
      message:
          "Vehicle exhuast is a major source of air pollution. Less cars on the road results in less emission.",
      image: AppImages.publicTransportIcon,
    ),
    HealthTip(
      title: "Service your car regularly",
      message:
          "Regular inspections can maximize fuel efficiency, which reduces vehicle emissions.",
      image: AppImages.carServiceIcon,
    ),
    HealthTip(
      title: "Walk or Cycle regularly",
      message:
          "Walk or cycle to lower your individual carbon footprint while improving your health too.",
      image: AppImages.cycleIcon,
    ),
    HealthTip(
      title: "Become a champion for clean air",
      message:
          "Join our air quality campaign and advocate for clean air in your community.",
      image: AppImages.championIcon,
    ),
  ];
}

class HealthTip {
  final String title;
  final String message;
  final AssetImage? image;

  const HealthTip({required this.title, required this.message, this.image});
}
