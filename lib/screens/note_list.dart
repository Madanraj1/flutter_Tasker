import 'package:flutter/material.dart';
import 'dart:async';
import '../DB/database_helper.dart';
import '../note.dart';
import 'note_details.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DataBaseHelper databaseHelper = DataBaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasker'),
        backgroundColor: Colors.greenAccent,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellowAccent,
          child: Icon(Icons.add),
          onPressed: () {
            navigateToDetail(Note("", "", 2, ""), 'Add Note');
          }),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.deepOrange,
            elevation: 5.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://learncodeonline.in/mascot.png"),
              ),
              title: Text(
                // this.noteList[index].title,
                this.noteList[index].title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
              subtitle: Text(
                this.noteList[index].date,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.open_in_new,
                  color: Colors.white,
                ),
                onTap: () {
                  navigateToDetail(this.noteList[index], "EditTodo");
                },
              ),
            ),
          );
        });
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
