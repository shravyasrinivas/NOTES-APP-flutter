import 'package:apps/dbhelper.dart';
import 'package:flutter/material.dart';

class PLANUI extends StatefulWidget {
  @override
  _PLANUIState createState() => _PLANUIState();
}

class _PLANUIState extends State<PLANUI> {
  final dbhelper = Databasehelper.instance;
  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var mylist = List();
  List<Widget> children = new List<Widget>();
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
    mylist = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      mylist.add(row.toString());
      children.add(Card(
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                row['planner'],
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              onTap: () {
                //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => SecondRoute()),
               // );
              },
              trailing: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    dbhelper.deletedata(row['id']);
                    setState(() {});
                  }),
            ),
          )));
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
                "Add Note",
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
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (texteditingcontroller.text.isEmpty) {
                            setState(() {
                              errtext = "Can't Be Empty";
                              validated = false;
                            });
                          } else if (texteditingcontroller.text.length > 512) {
                            setState(() {
                              errtext = "Too may Chanracters";
                              validated = false;
                            });
                          } else {
                            addtodo();
                          }
                        },
                        color: Colors.blue,
                        child: Text("ADD",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      )
                    ],
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
      builder: (context, ftcont) {
        if (ftcont.hasData == null) {
          return Center(
            child: Text(
              "No Data",
            ),
          );
        } else {
          if (mylist.length == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "PLANNER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  "No Tasks!",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
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
                backgroundColor: Colors.blue,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "PLANNER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: Colors.black,
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
