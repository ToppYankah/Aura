import 'package:aura/helpers/utils/pollutant_util.dart';
import 'package:aura/network/api/measurements/models/latest_measurement_data.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_info/pollutant_card_cell.dart';

class PollutantsCard extends StatelessWidget {
  const PollutantsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeasurementsProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(builder: (context, constraint) {
          return SectionCard(
            useHorizontalSpace: false,
            margin: const EdgeInsets.only(bottom: 10, right: 10),
            title: const SectionCardTitle(
              "Pollutants",
              icon: Icons.auto_fix_high_rounded,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0)
                  .copyWith(bottom: 10),
              child: Wrap(
                children: _generatePollutantsCells(
                    provider.latest?.measurements ?? [],
                    (constraint.maxWidth / 2) - 20),
              ),
            ),
          );
        });
      },
    );
  }

  List<PollutantCell> _generatePollutantsCells(
      List<SimpleMeasurementData> parameters, double width) {
    List<PollutantCell> output = [];

    for (SimpleMeasurementData parameter in parameters) {
      if (PollutantUtils.pollutantBreakpoints.keys
          .contains(parameter.parameter)) {
        output.add(PollutantCell(data: parameter, width: width));
      }
    }

    return output;
  }
}
