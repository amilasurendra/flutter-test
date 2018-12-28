import 'package:flutter/material.dart';
import 'package:fb_events/list_item.dart';
import 'package:fb_events/model/event.dart';

class EventList extends StatelessWidget {

  final List<Event> event;

  EventList(this.event);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      children: _buildContactsList(),
    );
  }

  List<ListItem> _buildContactsList() {
    return event
        .map((event) => new ListItem(event))
        .toList();
  }
}