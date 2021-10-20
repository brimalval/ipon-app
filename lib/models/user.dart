class User {
  int _id;
  String _firstName;
  String _lastName;
  String _email;
  String _user;
  String _pass;
  User(this._firstName, this._lastName, this._email, this._user, this._pass);
  User.withID(this._id, this._firstName, this._lastName, this._email,
      this._user, this._pass);
  User.withMap(Map<String, dynamic> data) {
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    _user = data['user'];
    _pass = data['pass'];
    if (data['id'] != null) {
      _id = data['id'];
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'first_name': _firstName,
      'last_name': _lastName,
      'email': _email,
      'user': _user,
      'pass': _pass,
    };
    if (_id != null) {
      data['id'] = _id;
    }
    return data;
  }

  int get id {
    return _id;
  }

  String get firstName {
    return _firstName;
  }

  String get lastName {
    return _lastName;
  }

  String get email {
    return _email;
  }

  String get user {
    return _user;
  }

  String get pass {
    return _pass;
  }
}
