import 'package:flutter/material.dart';
import 'package:apps/note.dart';
import 'package:apps/databasehelper.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:apps/utility.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apps/dbhelper2.dart';
import 'package:apps/pic.dart';

class NoteDetail extends StatefulWidget {
  final String abTitle;
  final Note note;
  NoteDetail(this.note, this.abTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.abTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _date = new DateTime.now();
  Future<Null> _selectdate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2025));
    if (picked != null && picked != _date) {
      print('date selected : ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  File _image;
  String _imagepath;
  Future<File> imageFile;
  Image image;
  DBhelper dbhelper;
  List<Photo> images;

  void initState() {
    //super.initState();
    //images = [];
    //dbhelper = DBhelper();
    Loadimage();
    //refreshImages();
  }

  refreshImages() {
    dbhelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  gridView() {
    return ListView(
        // padding: EdgeInsets.all(5.0),
        children: <Widget>[
          //Container(
          //images.map((photo) {
          //return Utility.imageFromBase64String(photo.photo_name);
          //}),//height:280.0,
          //),
        ]);
    //crossAxisCount: 2,
    //childAspectRatio: 1.0,
    //mainAxisSpacing: 4.0,
    //crossAxisSpacing: 4.0,
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      Photo photo = Photo(0, imgString);
      dbhelper.save(photo);
      refreshImages();
    });
  }

  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  Future getcamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showdialogbox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Choose from"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("gallery"),
                  onTap: () {
                    getImage();
                  },
                ),
                Padding(padding: EdgeInsets.all(9.0)),
                GestureDetector(
                  child: Text("camera"),
                  onTap: () {
                    getcamera();
                  },
                ),
              ],
            )));
      },
    );
  }

  // Widget decideview() {
  // if (imageFile == null) {
  // return Text("no image");
  //} else {
  //return Image.file(imageFile, width: 200, height: 100);
  //}
  //}

  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  String abTitle;
  Note note;
  TextEditingController titleCont = TextEditingController();
  TextEditingController despCont = TextEditingController();
  NoteDetailState(this.note, this.abTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleCont.text = note.title;
    despCont.text = note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(abTitle),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    moveToLastScreen();
                  }),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "    choose priority of ur note as low or high :)",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: DropdownButton(
                              items:
                                  _priorities.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              style: textStyle,
                              value: getPriorityAsString(note.priority),
                              onChanged: (valSelByUser) {
                                setState(() {
                                  debugPrint('User selected $valSelByUser');
                                  updatePriorityAsInt(valSelByUser);
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: TextField(
                            controller: titleCont,
                            style: textStyle,
                            onChanged: (value) {
                              debugPrint(
                                  'Something changed in Title Text Field');
                              updateTitle();
                            },
                            decoration: InputDecoration(
                                hintText: 'Title',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: TextField(
                            controller: despCont,
                            style: textStyle,
                            onChanged: (value) {
                              debugPrint(
                                  'Something changed in Description Text Field');
                              updateDescription();
                            },
                            decoration: InputDecoration(
                                hintText: 'Description',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColorDark,
             g                     textColor:
                                      Theme.of(context).primaryColorLight,
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(color: Colors.blue),
                                    textScaleFactor: 1.5,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      debugPrint("Save button clicked");
                                      _save();
                                      _saveimage(_image.path);
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: 5.0,
                              ),
                              Expanded(
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColorDark,
                                  textColor:
                                      Theme.of(context).primaryColorLight,
                                  child: Text(
                                    'DELETE',
                                    style: TextStyle(color: Colors.red),
                                    textScaleFactor: 1.5,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      debugPrint("Delete button clicked");
                                      _delete();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.all(40.0),
                          child: Row(
                            children: <Widget>[
                              new Text('date & time: ${_date.toString()}'),
                            ],
                          ),
                        ),
                        _imagepath != null
                            ? Image.file(File(_imagepath))
                            : _image == null
                                ? Text("wanna import image?")
                                : Image.file(_image),
                        //new RaisedButton(
                        //color: Theme.of(context).primaryColorDark,
                        //textColor: Theme.of(context).primaryColorLight,
                        //child: Text(
                        //'IMPORT IMAGE',
                        //style: TextStyle(color: Colors.green),
                        //textScaleFactor: 1.5,
                        //),
                        //onPressed: () {
                        //setState(() {
                        //debugPrint("image button clicked");
                        //pickImageFromGallery();
                        //});
                        //},
                        //),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add_a_photo),
                onPressed: () {
                  setState(() {
                    _showdialogbox(context);
                  });
                })));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleCont.text;
  }

  void updateDescription() {
    note.description = despCont.text;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showbox('STATUS', 'YAY! YOUR NOTE GOT SAVED SUCCESSFULLY ');
    } else {
      _showbox('STATUS', 'OOPS! THERE WAS A PROBLEM SAVING UR NOTE');
    }
  }

  void _saveimage(path) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    saveimage.setString("imagepath", path);
  }

  void Loadimage() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveimage.getString("imagepath");
    });
  }

  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showbox('STATUS', 'NO NOTE GOT DELETED!');
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showbox('STATUS', 'YOUR NOTE IS DELETED');
    } else {
      _showbox('STATUS', 'OOPS! ERROR');
    }
  }

  void _showbox(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
