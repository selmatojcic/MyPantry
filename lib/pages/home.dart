import 'package:flutter/material.dart';
import 'package:my_pantry/data/database_helper.dart';
import 'package:my_pantry/model/ingredient.dart';
import 'package:my_pantry/pages/add_ingredient.dart';
import 'package:my_pantry/pages/recipes.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    // WidgetsFlutterBinding.ensureInitialized();
    return WillPopScope(
        onWillPop: () async => false,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: const Text('My Fridge'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
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
                        showAlertDialogForDeletingIngredient(context, ingredient.id);
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
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: 'btn1',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Recipes(),
                    ));
              },
              backgroundColor: Colors.orange[900],
              child: const Icon(Icons.menu_book),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: 'btn2',
              onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddIngredient(),
                      ));
                },
                backgroundColor: Colors.orange[900],
                child: const Icon(Icons.add),
            ),
          )
        ],
      ),

    )
    );
  }

  void showAlertDialogForDeletingIngredient(BuildContext context, int id) {
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
        DatabaseHelper.instance.remove(id);
        Navigator.pop(context);
        setState(() {});
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Would you like to delete this ingredient from Fridge?"),
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
}



