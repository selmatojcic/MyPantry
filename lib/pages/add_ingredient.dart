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
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBarText = const Text('Choose an ingredient');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/home').then((_) => setState(() {}));
          return true;
        },
    child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: customSearchBarText,
          actions: [
            IconButton(
                onPressed: () {setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBarText = const ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: 'type ingredient name...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBarText = const Text('Choose an ingredient');
                  }
                });
                },
                icon: customIcon,
            )
          ],
          // actions: <Widget>[
          //   Padding(
          //       padding: const EdgeInsets.only(right: 20),
          //       child: GestureDetector(
          //         onTap: () {},
          //         child: const Icon(
          //           Icons.search
          //         ),
          //       ),
          //   )
          // ],
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
                            onTap: () {
                              showAlertDialogForAddingIngredient(context, snapshot.data.results[index]);
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
    )
    );
  }

  void showToastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, //for iOS only
        textColor: Colors.black, //message text color
        backgroundColor: Colors.white,
        fontSize: 16.0
    );
  }

  void showAlertDialogForAddingIngredient(BuildContext context, Result result) {
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
      onPressed:  () async {
        await DatabaseHelper.instance.add(result);
        Navigator.pop(context);
        // var ingredients = await DatabaseHelper.instance.getIngredients();
        // for(int i = 0; i < ingredients.length; i++) {
        //   if (ingredients[i].id == result.id) {
        //     showToastMessage("You already have this in your fridge");
        //     Navigator.pop(context);
        //     setState(() {});
        //   }
        //   else {
        //     await DatabaseHelper.instance.add(result);
        //     Navigator.pop(context);
        //   }
        }
    );
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Would you like to add this ingredient to Fridge?"),
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

