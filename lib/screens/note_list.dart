import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker/DB/database_helper.dart';
import 'package:tasker/note.dart';
import 'package:tasker/screens/note_details.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
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
        title: Text(
          "Tasker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            navigateToDetail(
                Note(
                    priority: 2,
                    title: "",
                    description: "",
                    date: "",
                    name: ""),
                'Add Note');
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
            elevation: 4.0,
            color: Colors.blue[300],
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://learncodeonline.in/mascot.png"),
              ),
              title: Text(
                this.noteList[index].title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
              subtitle: Text(
                this.noteList[index].date,
                style: TextStyle(color: Colors.white),
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.open_in_new,
                  color: Colors.white,
                ),
                onTap: () {
                  navigateToDetail(this.noteList[index], 'Edit Todo');
                },
              ),
            ),
          );
        });
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(
        note: note,
        appBarTitle: title,
      );
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
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
