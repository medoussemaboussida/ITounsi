class User {
  String id;
  String username;
  DateTime dob;
  String email;
  String password;
  String role;
  String etat;
  String token; // Ajoutez ce champ si vous avez besoin du token

  User({
    required this.id,
    required this.username,
    required this.dob,
    required this.email,
    required this.password,
    required this.role,
    required this.etat,
    required this.token, // Incluez ce champ dans le constructeur
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Assurez-vous que json n'est pas null
    if (json == null) {
      throw ArgumentError('La donnée JSON ne peut pas être null');
    }

    return User(
      id: json["_id"] ?? "",
      username: json["username"] ?? "",
      dob: json["dob"] != null ? DateTime.parse(json["dob"]) : DateTime.now(), // Valeur par défaut si dob est null
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "",
      etat: json["etat"] ?? "", // Assurez-vous que le champ 'etat' existe dans les données
      token: json["token"] ?? "", // Assurez-vous que le champ 'token' est inclus si nécessaire
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "email": email,
    "password": password,
    "role": role,
    "etat": etat,
    "token": token, // Incluez ce champ dans la conversion en JSON
  };
}
