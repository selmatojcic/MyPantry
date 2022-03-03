import 'package:flutter/material.dart';
import 'package:my_pantry/data/database_helper.dart';
import 'package:my_pantry/services/api_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_pantry/model/ingredient.dart';

class AddIngredient extends StatefulWidget {
  const AddIngredient({Key? key}) : super(key: key);

  @override
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: const Text('Choose an ingredient'),
        ),
        body: FutureBuilder(
            future: ApiService.instance.fetchIngredients(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                    child: Text("Loading...")
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.number,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              await DatabaseHelper.instance.add(
                                snapshot.data.results[index]
                              );
                              // setState(() {
                              //
                              // });
                              showToastMessage("Added ${snapshot.data.results[index]} to Fridge");
                            },
                            title: Text(snapshot.data.results[index].name),
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data.results[index].image),
                            ),
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
}

