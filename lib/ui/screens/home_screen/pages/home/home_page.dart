import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/home_screen/widgets/aqi_graph/aqi_graph_card.dart';
import 'package:aura/ui/screens/home_screen/widgets/aqi_summary_card.dart';
import 'package:aura/ui/screens/home_screen/widgets/health_tip_card.dart';
import 'package:aura/ui/screens/home_screen/widgets/location_notifier.dart';
import 'package:aura/ui/screens/home_screen/widgets/overview/home_overview.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_info/pollutants_card.dart';
import 'package:aura/ui/screens/home_screen/widgets/sensor_info.dart';
import 'package:aura/ui/screens/home_screen/widgets/trend_graph/trend_graph_card.dart';
import 'package:flutter/material.dart';

class HomePage extends HomePageItem {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: const SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeOverview(),
                  CurrentLocationNotifier(),
                  AQISummaryCard(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: AQIGraphCard()),
                      Expanded(flex: 4, child: PollutantsCard()),
                    ],
                  ),
                  SensorInfo(),
                  ReadingsGraphCard(),
                  HealthTipsCard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
