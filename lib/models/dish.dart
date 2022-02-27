class Dish {
  int? id;
  String name;
  String? description;

  Dish({this.id, required this.name, this.description});

  factory Dish.fromDatabaseJson(Map<String, dynamic> data) => Dish(
    id: data['id'],
    name: data['name'],
    description: data['description'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}