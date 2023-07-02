import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/screens/aqi_summary_screen/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AQISummaryScreen extends StatelessWidget {
  const AQISummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeasurementsProvider>(builder: (context, provider, _) {
      final String name = provider.aqiDetails?.status.name ?? "Good";
      return AppScaffold(
        bodyBuilder: (_, __) {
          return SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppHeader(title: "AQI Summary"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...AQIUtil.statuses.map((status) {
                          final bool selected = status.name == name;
                          return SummaryCard(
                            key: GlobalKey(),
                            selected: selected,
                            status: status,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
