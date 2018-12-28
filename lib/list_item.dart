
import 'package:flutter/material.dart';
import 'package:fb_events/model/event.dart';

class ListItem extends StatelessWidget{

  final Event event;

  ListItem(this.event);

  @override
  Widget build(BuildContext context){
    return new ListTile( title: new Text(event.name) );
  }

}