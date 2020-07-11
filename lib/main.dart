import 'package:flutter/material.dart';
import 'package:apps/note_list.dart';
//import 'package:scheduled_notifications/scheduled_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.black,
      ),
      home: NoteList(),
    );
  }
}





