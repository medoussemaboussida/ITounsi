class Event {
  String id;
  String title;
  DateTime date;
  String description;
  String photo;
  String lieu;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.photo,
    required this.lieu,
  });

  /*factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["Title"],
        date: DateTime.parse(json["Date"]),
        description: json["Description"],
        photo: json["Photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Title": title,
        "Date": date.toIso8601String(),
        "Description": description,
        "Photo": photo,
    };*/
}

List<Event> EventList = [
  Event(
      id: "0",
      title: "Forum des entrprise 2023/24",
      date: DateTime.parse("2024-03-26 09:15"),
      description:
          "Esprit va organiser un forum des options cette année , soyez au rendez-vous ! eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
      photo: "assets/esprit.jpg",lieu: "Technopole Ghazela Bloc E"),
  Event(
      id: "0",
      title: "Forum des entrprise 2023/24",
      date: DateTime.parse("2024-03-26"),
      description:
          "Esprit va organiser un forum des options cette année , soyez au rendez-vous !",
      photo: "assets/esprit.jpg",lieu: "Technopole Ghazela Bloc E"),
   Event(
      id: "0",
      title: "Forum des entrprise 2023/24",
      date: DateTime.parse("2024-03-26"),
      description:
          "Esprit va organiser un forum des options cette année , soyez au rendez-vous !",
      photo: "assets/esprit.jpg",lieu: "Technopole Ghazela Bloc E"),
  Event(
      id: "0",
      title: "Forum des entrprise 2023/24",
      date: DateTime.parse("2024-03-26"),
      description:
          "Esprit va organiser un forum des options cette année , soyez au rendez-vous !",
      photo: "assets/esprit.jpg",lieu: "Technopole Ghazela Bloc E"),
   Event(
      id: "0",
      title: "Forum des entrprise 2023/24",
      date: DateTime.parse("2024-03-26"),
      description:
          "Esprit va organiser un forum des options cette année , soyez au rendez-vous !",
      photo: "assets/esprit.jpg",lieu: "Technopole Ghazela Bloc E"),
];
