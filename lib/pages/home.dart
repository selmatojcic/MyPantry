import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pantry/data/database_helper.dart';
import 'package:my_pantry/model/ingredient.dart';
import 'package:my_pantry/pages/add_ingredient.dart';
import 'package:my_pantry/pages/recipes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_pantry/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
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
                        // NotificationService().showNotification(1, ingredient.name, 'body', 10);
                        print('tapped ${ingredient.name} expires ${ingredient.expirationDate}');
                        showAlertDialogForDeletingIngredient(context, ingredient.id);
                      },
                        title: Text(ingredient.name),
                        subtitle: Text(
                            ingredient.expirationDate == null ? '' :
                              "expiration date: ${ingredient.expirationDate})"
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 10.0),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(ingredient.image),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            selectDate(context, ingredient);
                          },
                          icon: const Icon(Icons.calendar_month),
                        )
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

  selectDate(BuildContext context, Result result) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE65100),
              onPrimary: Colors.white,
              surface: Color(0xFFE65100),
              onSurface: Colors.white,
            ),
            // dialogBackgroundColor:Colors.blue[900],
          ), child: child!,
        );
      }
     );
    String formattedDate = DateFormat("dd-MM-yyyy").format(picked);
    setState(() {
        result.expirationDate = formattedDate;
    });
    print(result.expirationDate);
    await DatabaseHelper.instance.update(result);
  }
}



