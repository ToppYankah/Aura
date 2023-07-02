import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/health_tips_screen/data/health_tips_data.dart';
import 'package:flutter/material.dart';

class TipTile extends StatelessWidget {
  final HealthTip data;
  const TipTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80)
              .copyWith(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 33,
                  color: theme.heading,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Text(
                  data.message,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    color: theme.paragraphDeep,
                  ),
                ),
              ),
              if (data.image != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                        image: data.image!, width: constraints.maxWidth * 0.6),
                  ],
                ),
            ],
          ),
        );
      });
    });
  }
}
