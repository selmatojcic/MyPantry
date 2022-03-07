import 'package:flutter/material.dart';
import 'package:my_pantry/services/api_services.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _Recipes createState() => _Recipes();
}

class _Recipes extends State<Recipes> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar is widget.mealType
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Colors.orange[900],
      ),
        body: FutureBuilder(
            future: RecipeApiService.instance.fetchRecipes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                    child: Text("Loading...")
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: ListTile(
                            onTap: () { },
                            title: Text(snapshot.data[index].title),
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: Image.network(snapshot.data[index].image),
                          ),
                        ),
                      );
                    }
                );
              }
            }
        )
      );
  }

}