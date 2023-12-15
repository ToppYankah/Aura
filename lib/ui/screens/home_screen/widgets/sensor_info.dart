import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SensorInfo extends StatelessWidget {
  const SensorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      margin: EdgeInsets.only(bottom: 10),
      title: SectionCardTitle("Sensor Details", icon: Iconsax.monitor),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SensorInfoItem(
              title: "",
              displayValue: Text("Something"),
            ),
            SensorInfoItem(
              title: "",
              displayValue: Text("Something"),
            ),
            SensorInfoItem(
              title: "",
              displayValue: Text("Something"),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorInfoItem extends StatelessWidget {
  final String title;
  final Widget displayValue;
  const SensorInfoItem({
    super.key,
    required this.title,
    required this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          displayValue,
        ],
      ),
    );
  }
}
