import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/parameters_provider.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_selector/pollutant_selector_item.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_selector/pollutants_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PollutantSelector extends StatelessWidget {
  const PollutantSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: provider.isLoading
              ? const PollutantsShimmerLoader()
              : _generateParameters(context, provider: provider),
        );
      },
    );
  }
}

Widget _generateParameters(BuildContext context,
    {required LocationProvider provider}) {
  final parameterProvider = Provider.of<ParametersProvider>(context);

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.only(right: 20, left: 10),
    child: Row(
      children: (provider.selectedLocation?.parameters ?? [])
          .map(
            (parameter) => IntrinsicHeight(
              child: PollutantSelectorItem(
                data: parameter,
                onSelect: () => parameterProvider.parameter = parameter,
                active: parameter == parameterProvider.selectedParameter,
              ),
            ),
          )
          .toList(),
    ),
  );
}
