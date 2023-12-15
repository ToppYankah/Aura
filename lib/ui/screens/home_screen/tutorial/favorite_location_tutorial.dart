import 'package:aura/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FavoriteLocationTutorial extends StatelessWidget {
  const FavoriteLocationTutorial({super.key});

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
              "Favorite",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              size: 30,
              Iconsax.heart5,
              color: AppColors.secondary,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "Tap the favorite button to add this location to your favorite locations list.",
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
