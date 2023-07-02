import 'package:aura/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChangeLocationTutorial extends StatelessWidget {
  const ChangeLocationTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Change Location",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Iconsax.global,
              color: AppColors.secondary,
              size: 30,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "Click the flag icon to access the change location button and update your preferred location.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white60,
            ),
          ),
        )
      ],
    );
  }
}
