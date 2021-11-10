import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import './event_list.dart';

class EventGrid extends StatelessWidget {
  const EventGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Events>(context).item;
    return ListView.builder(
      itemCount: event.length,
      itemBuilder: (context, int) => ChangeNotifierProvider<Event>.value(
        value: event[int],
        child: EventList(),
      ),
    );
  }
}
