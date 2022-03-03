import 'package:flutter/material.dart';
import 'package:my_pantry/data/database_helper.dart';
import 'package:my_pantry/model/ingredient.dart';
import 'package:my_pantry/pages/add_ingredient.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    // WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: const Text('My Fridge'),
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
                      onLongPress: () {
                        setState(() {
                          DatabaseHelper.instance.remove(ingredient.id);
                        });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddIngredient(),
              ));
        },
        backgroundColor: Colors.orange[900],
        child: const Icon(Icons.add),
      )
    );
  }
}
void showToastMessage(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1, //for iOS only
      textColor: Colors.white, //message text color
      fontSize: 16.0
  );
}



