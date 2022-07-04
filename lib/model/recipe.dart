class Recipe {
  final int id;
  final String image;
  final String title;
  String? spoonacularSourceUrl;

  Recipe(
      {required this.id,
      required this.image,
      required this.title,
      this.spoonacularSourceUrl});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'],
        image: json['image'],
        title: json['title'],
        spoonacularSourceUrl: json['spoonacularSourceUrl']);
  }
}
