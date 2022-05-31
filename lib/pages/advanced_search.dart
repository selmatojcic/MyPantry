import 'package:flutter/material.dart';
import 'package:my_pantry/pages/recipes_by_ingredients.dart';
import '../data/database_helper.dart';
import '../model/ingredient.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key? key}) : super(key: key);

  @override
  _AdvancedSearch createState() => _AdvancedSearch();
}

class _AdvancedSearch extends State<AdvancedSearch> {
  List<Result> selectedIngredients = [];
  String text = 'SELECTED INGREDIENTS: ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: const Text('Select ingredients for a recipe'),
      ),
      body: Column (
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(text),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Result>>(
              future: DatabaseHelper.instance.getIngredients(),
              builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
                if(!snapshot.hasData) {
                  return const Center(
                      child: Text('Loading...')
                  );
                }
                return snapshot.data!.isEmpty ? const Center(child: Text('No ingredients in fridge')) : ListView(
                  children: snapshot.data!.map((ingredient) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            showAlertDialogForAddingIngredientToSearchList(context, ingredient);
                          },
                          title: Text(ingredient.name),
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(ingredient.image),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextButton(
              onPressed: () {
                if (selectedIngredients.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "You have to select at least one ingredient!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.orange[900],
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecipesByIngredients(),
                          settings: RouteSettings(
                              arguments: text
                          )
                      ));
                }
              },
              child: const Text(
                  'FIND RECIPE',
                  style: TextStyle(
                      color: Color(0xFFFFFFFF)
                  )
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange[900])),
            ),
          ),
        ]
      ),
    );
  }
  void showAlertDialogForAddingIngredientToSearchList(BuildContext context, Result result) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel",
        style: TextStyle(
            color: Color(0xFFE65100)),
      ),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes",
        style: TextStyle(
            color: Color(0xFFE65100)),
      ),
      onPressed:  () {
        selectedIngredients.add(result);
        changeText(result.name);
        Navigator.pop(context);
        setState(() {});
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Find recipe"),
      content: const Text("Would you like to find a recipe with this ingredient?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void changeText(String name) {
    setState(() {
      text += '\n$name';
    });
  }
}