import 'package:aura/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeRefreshTutorial extends StatelessWidget {
  const HomeRefreshTutorial({super.key});

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
              "Refresh",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Iconsax.refresh,
              color: AppColors.secondary,
              size: 30,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "Tap the refresh button to update the page with the latest information.",
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
