
import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:flutter/material.dart';

class StatusDefinition extends StatelessWidget {
  final AQIStatus status;
  final Color textColor;
  const StatusDefinition(
      {super.key, required this.status, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Container(
              width: 10,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: status.color,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  status.message,
                  style: TextStyle(color: textColor, height: 1.5, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


