class Event {
  String id;
  String title;
  DateTime event_date;
  String event_description;
  String event_photo;
  String place;

  Event({
    required this.id,
    required this.title,
    required this.event_date,
    required this.event_description,
    required this.event_photo,
    required this.place,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"]?? "",
        title: json["title"]?? "",
        event_date: DateTime.parse(json["event_date"]),
        event_description: json["event_description"]?? "",
        place: json["place"]?? "",
        event_photo: json["event_photo"]?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "event_date": event_date.toIso8601String(),
        "event_description": event_description,
        "event_photo": event_photo,
    };
}

List<Event> EventList = [];
