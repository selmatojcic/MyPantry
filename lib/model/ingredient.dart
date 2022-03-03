
class Result {

  final int id;
  final String name;
  final String image;

  Result({required this.id, required this.name, required this.image });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      name: json['name'],
      image: 'https://spoonacular.com/cdn/ingredients_100x100/' + json['image'],
    );
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image
    };
  }
}

class Ingredients {

  List<Result> results;
  final int offset;
  final int number;
  final int totalResults;

  Ingredients({required this.results, required this.offset, required this.number, required this.totalResults});

  factory Ingredients.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Result> resultsList = list.map((result) => Result.fromJson(result)).toList();
    return Ingredients(
      results: resultsList,
      offset: json['offset'],
      number: json['number'],
      totalResults: json['totalResults'],
    );
  }
}

