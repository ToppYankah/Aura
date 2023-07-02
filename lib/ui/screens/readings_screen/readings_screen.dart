import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/screens/home_screen/widgets/health_tip_card.dart';
import 'package:aura/ui/screens/readings_screen/widgets/hourly_chart.dart';
import 'package:aura/ui/screens/readings_screen/widgets/latest_reading_chart.dart';
import 'package:aura/ui/screens/readings_screen/widgets/readings_date_tab/readings_date_tab.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({super.key});

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> {
  @override
  void initState() {
    super.initState();
    CommonUtils.performPostBuild(
      context,
      Provider.of<MeasurementsProvider>(context, listen: false)
          .getRecordedMeasurements,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeader(title: "Daily Readings"),
              DateTab(
                onDayChange: (Moment date) =>
                    Provider.of<MeasurementsProvider>(context, listen: false)
                        .setDate = date,
              ),
              const Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SectionCard(
                        title: SectionCardTitle("Latest Reading",
                            icon: IconlyLight.activity),
                        margin: EdgeInsets.only(bottom: 10),
                        child: LatestReadingsChart(),
                      ),
                      SectionCard(
                        margin: EdgeInsets.only(bottom: 10),
                        title: SectionCardTitle(
                          "Weekly Pattern",
                          icon: IconlyLight.time_circle,
                        ),
                        child: HourOfDayChart(),
                      ),
                      HealthTipsCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
