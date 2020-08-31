class Note {
  int _id, _priority;
  String _description, _date, _title;

  Note(this._description, this._date, this._priority, this._title);
  Note.withId(
      this._id, this._description, this._date, this._priority, this._title);

// all the getters
  int get id => _id;
  int get priority => _priority;
  String get description => _description;
  String get date => _date;
  String get title => _title;

// all the setters
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newdescription) {
    if (newdescription.length <= 255) {
      this._description = newdescription;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set priority(int newpriority) {
    if (newpriority >= 1 && newpriority <= 2) {
      this._priority = newpriority;
    }
  }

// used to save and retrive from DB

// convert note obj to map obj
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
