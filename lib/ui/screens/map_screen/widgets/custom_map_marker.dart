import 'package:flutter/material.dart';

class CustomMapMarker extends StatelessWidget {
  const CustomMapMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3, color: Colors.white),
      ),
    );
  }
}
