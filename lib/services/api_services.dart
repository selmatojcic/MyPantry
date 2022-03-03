import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_pantry/model/ingredient.dart';

class ApiService {
  //The API service will be a singleton, therefore create a private constructor
  //ApiService._instantiate(), and a static instance variable
  ApiService._instantiate();
  static final ApiService instance = ApiService._instantiate();

  final String _baseURL = "api.spoonacular.com";
  final String query = "apple";
  static const String API_KEY ="d5e5abb43ff04413b72c202719110909";

  Future<Ingredients> fetchIngredients() async {
    Map<String, String> parameters = {
      'query' : query,
      'apiKey': API_KEY,
    };

    Uri uri = Uri.https(
      _baseURL,
      'food/ingredients/search',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      final data = json.decode(response.body);
      print("dataaa $data");
      Ingredients ingredients = Ingredients.fromJson(data);
      print("ingredientssss $ingredients");

      return ingredients;
    } catch (err) {
      throw err.toString();
    }
  }
}