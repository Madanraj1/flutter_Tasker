class Note {
  int id, priority;
  String title, description, date, name;

  Note({this.priority, this.title, this.description, this.date, this.name});
  Note.withId(
      {this.id,
      this.priority,
      this.title,
      this.description,
      this.date,
      this.name});

// all the getters
  int get getId => id;
  int get getPriority => priority;
  String get getTitle => title;
  String get getdescription => description;
  String get getDate => date;
  String get getName => name;

  // all the setters

  set setpriority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this.priority = newPriority;
    }
  }

  set setTitle(String newTitle) {
    if (newTitle.length <= 50) {
      this.title = newTitle;
    }
  }

  set setDescription(String newDescription) {
    if (newDescription.length <= 255) {
      this.description = newDescription;
    }
  }

  set setDate(String newDate) {
    this.date = newDate;
  }

  set setName(String newName) {
    if (newName.length <= 100) {
      this.name = newName;
    }
  }

  Map<String, dynamic> convertToMap() {
    var map = Map<String, dynamic>();
    if (getId != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    map['name'] = name;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.priority = map['priority'];
    this.date = map['date'];
  }
}
