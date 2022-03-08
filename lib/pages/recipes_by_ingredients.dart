import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_pantry/model/recipe.dart';
import 'package:my_pantry/pages/advanced_search.dart';
import 'package:my_pantry/services/api_services.dart';
import '../widget/search_widget.dart';

class RecipesByIngredients extends StatefulWidget {
  const RecipesByIngredients({Key? key}) : super(key: key);

  @override
  _RecipesByIngredients createState() => _RecipesByIngredients();
}

class _RecipesByIngredients extends State<RecipesByIngredients> {

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as String;
    String query = formatString(argument);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes by ingredients'),
        backgroundColor: Colors.orange[900],
      ),
      body: FutureBuilder<List<Recipe>>(
          future: RecipeApiService.instance.fetchRecipes(query),
          builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {},
                      leading: Image.network(
                        recipe.image,
                        fit: BoxFit.cover,
                      ),
                      title: Text(recipe.title),
                      contentPadding: const EdgeInsets.all(8.0),
                    ),
                  ),
                );
              },
            );
          },
        )
    );
  }

  String formatString(String argument) {
    String temp1 = argument.replaceAll('SELECTED INGREDIENTS: ', '');
    String temp2 = temp1.replaceAll('\n', ',+');
    String temp3 = temp2.substring(2);
    return temp3;
  }

}
