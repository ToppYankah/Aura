import 'package:aura/ui/screens/choose_location_screen/widgets/location_header_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CountrySearchButton extends StatelessWidget {
  final VoidCallback? onStartSearch;
  final VoidCallback? onCancelSearch;
  const CountrySearchButton(
      {super.key, this.onStartSearch, this.onCancelSearch});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isVisible) {
      return 
      HeaderButton(
        iconSize: 25,
        icon: isVisible ? Icons.close : Icons.search,
        onTap: isVisible ? onCancelSearch : onStartSearch,
      );
    });
  }
}
