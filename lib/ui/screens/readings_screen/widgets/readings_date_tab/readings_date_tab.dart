import 'package:aura/providers/measurements_provider.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:aura/ui/screens/readings_screen/models/date_info.dart';
import 'package:aura/ui/screens/readings_screen/widgets/readings_date_tab/readings_date_tab_item.dart';
import 'package:provider/provider.dart';

class DateTab extends StatefulWidget {
  final Function(Moment) onDayChange;
  const DateTab({super.key, required this.onDayChange});

  @override
  State<DateTab> createState() => _DateTabState();
}

class _DateTabState extends State<DateTab> {
  final List<Moment> _tabs = [];

  @override
  void initState() {
    super.initState();
    _fillTabs();
  }

  void _fillTabs() {
    late Moment date;
    final Moment today = Moment.now();

    for (var i = 0; i < 7; i++) {
      date = today.lastSunday().add(Duration(days: i));
      _tabs.add(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeasurementsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10)
          .copyWith(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _tabs.map((e) {
          String dateName = e.format('dddd').substring(0, 3);
          return DateTabItem(
            onTap: () => widget.onDayChange(e),
            active: e.day == provider.selectedDate.day,
            date: DateInfo(day: dateName, dayNumber: e.day),
            disabled:
                e.millisecondsSinceEpoch > Moment.now().millisecondsSinceEpoch,
          );
        }).toList(),
      ),
    );
  }
}
