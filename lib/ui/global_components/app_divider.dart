import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final String? text;
  final double space;
  const AppDivider({super.key, this.text, this.space = 30});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: space),
        child: Row(
          children: [
            Expanded(
              child: Divider(
                indent: 30,
                thickness: 1,
                color: _ ? Colors.white10 : Colors.black12,
              ),
            ),
            if (text != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  text!,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: theme.paragraph),
                ),
              ),
            Expanded(
              child: Divider(
                endIndent: 30,
                thickness: 1,
                color: _ ? Colors.white10 : Colors.black12,
              ),
            )
          ],
        ),
      );
    });
  }
}
