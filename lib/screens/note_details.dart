import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasker/DB/database_helper.dart';
import 'package:tasker/note.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle;
  Note note;
  NoteDetail({this.note, this.appBarTitle});
  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.appBarTitle, this.note);
}

class _NoteDetailState extends State<NoteDetail> {
  static var _priority = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  _NoteDetailState(this.appBarTitle, this.note);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          backgroundColor: Colors.amber,
          appBar: AppBar(
            title: Text(appBarTitle),
            backgroundColor: Colors.pink,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                    //dropdown menu
                    child: new ListTile(
                      leading: const Icon(Icons.low_priority),
                      title: DropdownButton(
                          items: _priority.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            );
                          }).toList(),
                          value: getPriorityAsString(note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                  ),
                  // Second Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        icon: Icon(Icons.title),
                      ),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                        labelText: 'Details',
                        icon: Icon(Icons.details),
                      ),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void updateTitle() {
    note.setTitle = titleController.text;
  }

  void updateDescription() {
    note.setDescription = descriptionController.text;
  }

  void updateName() {
    note.setName = nameController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    moveToLastScreen();
    note.setDate = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.getId != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      showAlertDialog('Status', "Note Saved Successfully");
    } else {
      showAlertDialog("Status", "Problem Saving Note");
    }
  }

  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      showAlertDialog("Statis", "Firs Add aNote");
      return;
    }
    int result = await helper.deleteNote(note.getId);
    if (result != 0) {
      showAlertDialog('Status', "Note Deleted Successfully");
    } else {
      showAlertDialog("Status", "ERROR!!!!!!!!");
    }
  }

  // convert to int to save into database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.setpriority = 1;
        break;
      case 'Low':
        note.setpriority = 2;
        break;
    }
  }

  // covert int to string to show user
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priority[0];
        break;
      case 2:
        priority = _priority[1];
        break;
      default:
    }
    return priority;
  }

  void showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
