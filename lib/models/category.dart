class Category {
  int _id;
  int _iconIndex;
  int _userId;
  String _name;
  bool _isDefault;
  bool isExpense;

  Category(this._iconIndex, this._userId, this._name, this._isDefault,
      {this.isExpense = true});
  Category.withID(
      this._id, this._iconIndex, this._userId, this._name, this._isDefault,
      {this.isExpense = true});
  Category.withMap(Map<String, dynamic> data) {
    _iconIndex = data['icon_index'];
    _userId = data['user_id'];
    _name = data['name'];
    _isDefault = (data['is_default'] == 1) ? true : false;
    if (data['id'] != null) _id = data['id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'icon_index': _iconIndex,
      'user_id': _userId,
      'name': _name,
      'is_default': (_isDefault) ? 1 : 0,
    };
    if (_id != null) data['id'] = _id;
    return data;
  }

  bool setIsExpense(bool val) => isExpense = val;

  int get id => _id;
  int get userId => _userId;
  int get iconIndex => _iconIndex;
  String get name => _name;
  bool get isDefault => _isDefault;
  bool get isAnExpense => isExpense;
}
