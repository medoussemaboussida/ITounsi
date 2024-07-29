class News {
  String id;
  String category;
  DateTime date;
  String description;
  String photo;

  News({
    required this.id,
    required this.category,
    required this.date,
    required this.description,
    required this.photo,
  });
/*
    factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        date: DateTime.parse(json["Date"]),
        description: json["Description"],
        photo: json["Photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Date": date.toIso8601String(),
        "Description": description,
        "Photo": photo,
    };*/}
  List<News> NewsList = [
    News(
        id: "0",
        category: "data science",
        date: DateTime.parse("2024-03-26 09:15"),
        description:
            "Join U.S. Ambassador to Tunisia Joey Hood and Tunisian Minister of Communication Technologies Ben Neji to learn about investment opportunities in cybersecurity and cloud computing in Tunisia .Tunisia has made the development of its digital economy one of its top priorities for the coming years, which stands to offer significant commercial opportunities for information and communication technologies (ICT) providers, especially in the cloud and cybersecurity sectors. The government’s recognition of the importance of digital transformation and the associated risks has led to the implementation of initiatives to enhance cybersecurity measures and promote cloud adoption. ",
        photo: "assets/bigTech.jpg"),
    News(
        id: "1",
        category: "Cyber Security",
        date: DateTime.parse("2024-03-26 09:15"),
        description:
            "Join U.S. Ambassador to Tunisia Joey Hood and Tunisian Minister of Communication Technologies Ben Neji to learn about investment opportunities in cybersecurity and cloud computing in Tunisia .Tunisia has made the development of its digital economy one of its top priorities for the coming years, which stands to offer significant commercial opportunities for information and communication technologies (ICT) providers, especially in the cloud and cybersecurity sectors. The government’s recognition of the importance of digital transformation and the associated risks has led to the implementation of initiatives to enhance cybersecurity measures and promote cloud adoption. ",
        photo: "assets/bigTech.jpg"),
    News(
        id: "2",
        category: "Cyber Security",
        date: DateTime.parse("2024-03-26 09:15"),
        description:
            "Join U.S. Ambassador to Tunisia Joey Hood and Tunisian Minister of Communication Technologies Ben Neji to learn about investment opportunities in cybersecurity and cloud computing in Tunisia .Tunisia has made the development of its digital economy one of its top priorities for the coming years, which stands to offer significant commercial opportunities for information and communication technologies (ICT) providers, especially in the cloud and cybersecurity sectors. The government’s recognition of the importance of digital transformation and the associated risks has led to the implementation of initiatives to enhance cybersecurity measures and promote cloud adoption. ",
        photo: "assets/bigTech.jpg"),
    News(
        id: "3",
        category: "IOT",
        date: DateTime.parse("2024-03-26 09:15"),
        description:
            "Join U.S. Ambassador to Tunisia Joey Hood and Tunisian Minister of Communication Technologies Ben Neji to learn about investment opportunities in cybersecurity and cloud computing in Tunisia .Tunisia has made the development of its digital economy one of its top priorities for the coming years, which stands to offer significant commercial opportunities for information and communication technologies (ICT) providers, especially in the cloud and cybersecurity sectors. The government’s recognition of the importance of digital transformation and the associated risks has led to the implementation of initiatives to enhance cybersecurity measures and promote cloud adoption. ",
        photo: "assets/bigTech.jpg"),
    News(
        id: "4",
        category: "Cyber Security",
        date: DateTime.parse("2024-03-26 09:15"),
        description:
            "Join U.S. Ambassador to Tunisia Joey Hood and Tunisian Minister of Communication Technologies Ben Neji to learn about investment opportunities in cybersecurity and cloud computing in Tunisia .Tunisia has made the development of its digital economy one of its top priorities for the coming years, which stands to offer significant commercial opportunities for information and communication technologies (ICT) providers, especially in the cloud and cybersecurity sectors. The government’s recognition of the importance of digital transformation and the associated risks has led to the implementation of initiatives to enhance cybersecurity measures and promote cloud adoption. ",
        photo: "assets/bigTech.jpg"),
  ];

