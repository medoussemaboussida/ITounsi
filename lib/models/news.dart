class News {
  String id;
  String category;
  DateTime news_date;
  String description;
  String news_photo;

  News({
    required this.id,
    required this.category,
    required this.news_date,
    required this.description,
    required this.news_photo,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"]?? "",
        category: json["category"]?? "",
        description: json["description"]?? "",
        news_photo: json["news_photo"]?? "",
        news_date: DateTime.parse(json["news_date"]),
      );

      
    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "description": description,
        "news_photo": news_photo,
        "news_date": news_date.toIso8601String(),

    };}
  List<News> NewsList = [];

