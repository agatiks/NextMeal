class Dish {
  int? id;
  String name;
  String category;
  String? url;

  Dish({this.id, required this.name, required this.category, this.url});

  factory Dish.fromDatabaseJson(Map<String, dynamic> data) => Dish(
    id: data['id'],
    name: data['name'],
    url: data['url'],
    category: data['category']
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "name": name,
    "url": url,
    "category": category,
  };
}