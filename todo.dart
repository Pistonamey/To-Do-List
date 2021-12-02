// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';

class todoui extends StatefulWidget {
  @override
  _todouiState createState() => _todouiState();
}

class _todouiState extends State<todoui> {
  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var myitems = [];
  List<Widget> children = <Widget>[];

  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated = true;
      errtext = "";
    });
  }

  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Raleway",
              ),
            ),
            onLongPress: () {
              dbhelper.deletedata(row['id']);
              setState(() {});
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add a New Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val) {
                      todoedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (texteditingcontroller.text.isEmpty) {
                              setState(() {
                                errtext = "Can't Be Empty";
                                validated = false;
                              });
                            } else if (texteditingcontroller.text.length >
                                512) {
                              setState(() {
                                errtext = "Too may Characters";
                                validated = false;
                              });
                            } else {
                              addtodo();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, //background
                            onPrimary: Colors.white,
                          ), // foreground
                          child: Text("ADD",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Raleway",
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text(
              "No Data",
            ),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                centerTitle: true,
                title: Text(
                  "Your Task manager",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  "Click on the '+' button to add a new task",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                centerTitle: true,
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: Colors.white,

              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}
