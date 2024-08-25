class Comment {
  String id;
  String userId;
  String newsId;
  String commentText;
  DateTime commentDate;
   String username; // Ajoute ce champ pour stocker le nom d'utilisateur

  Comment({
    required this.id,
    required this.userId,
    required this.newsId,
    required this.commentText,
    required this.commentDate,
        required this.username, // Ajoute ce champ au constructeur
  });

  // Factory constructor to create a Comment object from JSON
  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"] ?? "",
        userId: json["user"] ?? "",
        newsId: json["news"] ?? "",
        commentText: json["commentText"] ?? "",
        commentDate: DateTime.parse(json["commentDate"] ?? DateTime.now().toIso8601String()),
              username: json['userId']['username'], // Assure-toi que ce chemin correspond à la structure des données renvoyées
      );

  // Method to convert a Comment object to JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "user": userId,
        "news": newsId,
        "commentText": commentText,
        "commentDate": commentDate.toIso8601String(),
      };
}
