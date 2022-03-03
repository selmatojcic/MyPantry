import 'package:flutter/material.dart';
import 'package:my_pantry/data/database_helper.dart';
import 'package:my_pantry/model/ingredient.dart';
import 'package:my_pantry/pages/add_ingredient.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
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
                return Center(
                  child: ListTile(
                    title: Text(ingredient.name),
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

//   WidgetsFlutterBinding.ensureInitialized();


