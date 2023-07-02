import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/response.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:flutter/material.dart';

class StreetNameText extends StatefulWidget {
  final TextStyle? style;
  final bool withCountry;
  final Coordinates coords;

  const StreetNameText(
      {super.key, required this.coords, this.style, this.withCountry = false});

  @override
  State<StreetNameText> createState() => _StreetNameTextState();
}

class _StreetNameTextState extends State<StreetNameText> {
  String? _cityName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    CommonUtils.performPostBuild(context, () async {
      _cityName = await CommonUtils.getLocationCity(
        widget.coords,
        withCountry: widget.withCountry,
      );
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void didUpdateWidget(covariant StreetNameText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.coords != widget.coords) {
      CommonUtils.performPostBuild(context, () async {
        _cityName = await CommonUtils.getLocationCity(
          widget.coords,
          withCountry: widget.withCountry,
        );
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (_loading) const AppLoader(size: 10),
        Text(
          _loading ? "Loading..." : _cityName ?? "Unknown City",
          style: widget.style,
        ),
      ],
    );
  }
}
