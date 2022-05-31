import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_pantry/model/recipe.dart';
import 'package:my_pantry/pages/advanced_search.dart';
import 'package:my_pantry/services/api_services.dart';
import '../widget/search_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _Recipes createState() => _Recipes();
}

class _Recipes extends State<Recipes> {
  List<Recipe> recipeList = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(VoidCallback callback, { Duration duration = const Duration(milliseconds: 2000)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final recipes = await RecipeApiService.instance.fetchRecipes('apple');

    setState(() {
      recipeList = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar is widget.mealType
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Colors.orange[900],
      ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdvancedSearch(),
                          ));
                    },
                    child:  const Text(
                        'ADVANCED SEARCH',
                        style: TextStyle(
                            color: Color(0xFFFFFFFF))
                    ),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange[900])),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: recipeList.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeList[index];
                    return buildRecipe(recipe);
                  },
                )
            )
          ],
        ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search recipe',
    onChanged: searchRecipe,
  );

  Future searchRecipe(String query) async => debounce(() async {
    final recipes = await RecipeApiService.instance.fetchRecipes(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      recipeList = recipes;
    });
  });

  Widget buildRecipe(Recipe recipe) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: Card(
      child: ListTile(
        onTap: () async {
          Recipe recipeResponse = await RecipeDetailsApiService.instance.fetchRecipeUrl(recipe.id);
          try {
            launch(recipeResponse.spoonacularSourceUrl);
          } catch (e) {
            print(e);
          }
        },
        leading: Image.network(
          recipe.image,
          fit: BoxFit.cover,
        ),
        title: Text(recipe.title),
        contentPadding: const EdgeInsets.all(8.0),
      ),
    ),
  );
}
