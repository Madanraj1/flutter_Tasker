import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table_DB';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colName = 'name';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'tasker.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colDate TEXT, $colName TEXT, $colPriority INTEGER )');
  }

// getting data from the Database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.convertToMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.convertToMap(),
        where: '$colID = ?', whereArgs: [note.getId]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete(' DELETE FROM $noteTable where $colID = $id');
    return result;
  }

// getting the total counts of notes stored in the database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

// getting the list of the notes
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();

    int count = noteMapList.length;

    List<Note> noteList = List<Note>();

    for (var i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
