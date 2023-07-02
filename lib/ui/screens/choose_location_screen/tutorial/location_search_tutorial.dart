import 'package:flutter/material.dart';

class LocationSearchTutorial extends StatelessWidget {
  const LocationSearchTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Search 🔍",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "Find countries quickly and effortlessly. Enter your query and let the results guide you!",
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
