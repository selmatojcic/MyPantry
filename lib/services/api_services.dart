import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_pantry/model/ingredient.dart';
import 'package:my_pantry/model/recipe.dart';


class IngredientApiService {
  IngredientApiService._instantiate();
  static final IngredientApiService instance = IngredientApiService._instantiate();

  final String _baseURL = "api.spoonacular.com";
  // static const String API_KEY ="d5e5abb43ff04413b72c202719110909";
  static const String API_KEY ="b11fb3610d944e32994f74d8fc8176fb";

  Future<Ingredients> fetchIngredients(String query) async {
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
      Ingredients ingredients = Ingredients.fromJson(data);
      return ingredients;
    } catch (err) {
      throw err.toString();
    }
  }
}

class RecipeApiService {
  RecipeApiService._instantiate();
  static final RecipeApiService instance = RecipeApiService._instantiate();

  final String _baseURL = "api.spoonacular.com";
  // static const String API_KEY ="d5e5abb43ff04413b72c202719110909";
  static const String API_KEY ="b11fb3610d944e32994f74d8fc8176fb";

  Future<List<Recipe>> fetchRecipes(String ingredients) async {
    Map<String, String> parameters = {
      'ingredients': ingredients,
      'apiKey': API_KEY,
    };

    Uri uri = Uri.https(
      _baseURL,
      '/recipes/findByIngredients',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      final parsedData = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<Recipe> recipes = parsedData.map<Recipe>((json) => Recipe.fromJson(json)).toList();
      return recipes;
    } catch (err) {
      throw err.toString();
    }
  }
}