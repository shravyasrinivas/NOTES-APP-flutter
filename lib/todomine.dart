import 'package:apps/dbhelper.dart';
import 'package:flutter/material.dart';
main() {
  runApp(MYFIRST());
}

class MYFIRST extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MYFIRSTState();
}

class _MYFIRSTState extends State<MYFIRST> {
  final dbhelper = Databasehelper.instance;
  final cont = TextEditingController();
  bool validated = true;
  String errtxt = " ";
  String editedvalue = " ";
  var mylist = List();
  List<Widget> children = new List<Widget>();
  void addtonote() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: editedvalue,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    editedvalue = "";
    setState(() {
      validated = true;
      errtxt = "";
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
      margin: EdgeInsets.all(3.0),
      child: Container(
        padding: EdgeInsets.all(10),
        child: (ListTile(
          title: Text(
            row['planner'],
            style: TextStyle(fontSize: 20.0),
          ),
          onLongPress: () {
              
              dbhelper.deletedata(row['id']);
              setState(() {});},
        )
        ),
      )
      )
      );
      });
    return Future.value(true);
   }
  void showalertdialog() {
      cont.text = "";
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
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: cont,
                    autofocus: true,
                    onChanged: (_ab) {
                      editedvalue = _ab;
                    },
                    decoration: InputDecoration(
                      errorText: validated ? null : errtxt,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (cont.text.isEmpty) {
                            setState(() {
                              errtxt = "please type anything";
                              validated = false;
                            });
                          } else if (cont.text.length > 10) {
                            setState(() {
                              errtxt = "too many characters";
                              validated = false;
                            });
                          } else {
                            addtonote();
                          }
                        },
                        child: Text(
                          "ADD",
                          style: TextStyle(color: Colors.white),
                        ),
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
      builder: (context, sn) {
        if (sn.hasData == null) {
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
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.lightBlue,
                hoverColor: Colors.purple,
              ),
              appBar: AppBar(
                title: Text(
                  "PLANNER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              backgroundColor: Colors.black12,
              body: Center(
               child: Container(
              decoration: ShapeDecoration(
              color: Colors.black,
              shape: Border.all(
              color: Colors.red,
                  width: 2.0,
                ) 
              ),
                child: const Text(
                  "No Tasks",textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.white,fontSize: 20,),
                ),)
              ),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.lightBlue,
                hoverColor: Colors.purple,
              ),
              appBar: AppBar(
                title: Text(
                  "PLANNER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              backgroundColor: Colors.black12,
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
