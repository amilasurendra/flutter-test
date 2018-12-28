class Event{
  
  final String name;
  final String description;

  const Event({this.name, this.description});

  Event.fromJSON(Map jsonMap) : name = jsonMap['name'], description = jsonMap['description'];
  
}