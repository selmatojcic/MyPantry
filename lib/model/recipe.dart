
class Recipe {

  final int id;
  final String image;
  final String title;

  Recipe({required this.id, required this.image, required this.title });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      image: json['image'],
      title: json['title'],
    );
  }
}




