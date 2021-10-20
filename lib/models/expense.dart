class IncomeExpense {
  int _id;
  int _userId;
  int _unixEntryDate;
  int _categoryId;
  int _amount;
  String _name;
  bool isExpense;

  IncomeExpense(this._categoryId, this._userId, this._name, this._amount, this._unixEntryDate,
      {this.isExpense = true});
  IncomeExpense.withID(
      this._id, this._categoryId, this._userId, this._name, this._amount, this._unixEntryDate,
      {this.isExpense = true});
  IncomeExpense.withMap(Map<String, dynamic> data) {
    _categoryId = data['category_id'];
    _userId = data['user_id'];
    _name = data['name'];
    _amount = data['amount'];
    _unixEntryDate = data['unix_entry_date'];
    if (data['id'] != null) _id = data['id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'category_id': _categoryId,
      'user_id': _userId,
      'name': _name,
      'unix_entry_date': _unixEntryDate,
      'amount' : _amount,
    };
    if (_id != null) data['id'] = _id;
    return data;
  }

  int get id => _id;

  int get userId => _userId;

  int get amount => _amount;

  int get categoryId => _categoryId;

  int get unixEntryDate => _unixEntryDate;

  String get name => _name;

  bool get isAnExpense => isExpense;

  void setUserId(int id){
    _userId = id;
  }
}
