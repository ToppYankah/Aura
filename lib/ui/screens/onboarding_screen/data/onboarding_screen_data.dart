import 'package:aura/resources/app_images.dart';
import 'package:aura/resources/app_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingScreenData {
  OnboardingScreenData._();

  static List<OnboardingInfo> data = [
    OnboardingInfo(
      title: "Plan Your Life\nAround Air Quality",
      description:
          "Customised alerts based on real-time air quality updates to avoid harmful pollutants.",
      image: Transform.scale(
        scale: 1,
        child: Transform.translate(
          offset: const Offset(0, 110),
          child: const Image(image: AppImages.phone),
        ),
      ),
    ),
    OnboardingInfo(
      title: "Your Window to the\nAir Quality World",
      description:
          "Explore global air quality, track local conditions, and gain a pollution perspective",
      image: Transform.scale(
        scale: 0.9,
        child: Transform.translate(
          offset: const Offset(0, 120),
          child: SvgPicture.asset(AppSvgs.world),
        ),
      ),
    ),
    OnboardingInfo(
      title: "Get Real-Time Updates\non Your Air Quality",
      description:
          "Stay informed effortlessly with continuous air quality monitoring and historical tracking",
      image: Transform.scale(
        scale: 1.2,
        child: Transform.translate(
          offset: const Offset(0, 60),
          child: const Image(image: AppImages.phoneStats),
        ),
      ),
    ),
  ];
}

class OnboardingInfo {
  final String title;
  final Widget image;
  final String description;

  OnboardingInfo(
      {required this.title, required this.description, required this.image});
}
