class Character {
  final int id;
  final String name;
  final String status;

  Character({required this.id, required this.name, required this.status});

  factory Character.fromJson(Map<String, dynamic> json) =>
      Character(id: json["id"], name: json["name"], status: json["status"]);
}
