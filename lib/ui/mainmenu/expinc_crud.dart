import 'package:flutter/material.dart';
import 'package:project/iconlist.dart';
import 'package:project/models/category.dart';
import 'package:project/models/expense.dart';
import 'package:project/palette.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/ipon_expense_or_income.dart';
import 'package:project/ui/ipon_tfield.dart';
import 'package:project/ui/large_button.dart';
import 'package:project/util/DBHelper.dart';

class ExpenseIncomeForm extends StatefulWidget {
  final bool isEditing;
  final Function refreshListener;
  final IncomeExpense transactionToBeEdited;
  final int unixDate;
  final List<Category> expenseCategories;
  final List<Category> incomeCategories;
  final int currUserId;
  final bool isExpense;
  ExpenseIncomeForm({
    this.isEditing = true,
    this.isExpense,
    this.refreshListener,
    this.transactionToBeEdited,
    this.unixDate,
    this.expenseCategories,
    this.incomeCategories,
    this.currUserId,
  });

  @override
  _ExpenseIncomeFormState createState() => _ExpenseIncomeFormState(
        isEditing: isEditing,
        refreshListener: refreshListener,
        transactionToBeEdited: transactionToBeEdited,
        unixDate: unixDate,
        expenseCategories: expenseCategories,
        incomeCategories: incomeCategories,
        currUserId: currUserId,
        isExpense: isExpense,
      );
}

class _ExpenseIncomeFormState extends State<ExpenseIncomeForm> {
  final Function refreshListener;
  final IncomeExpense transactionToBeEdited;
  final List<Category> expenseCategories;
  final List<Category> incomeCategories;
  final int unixDate;
  final int currUserId;
  bool isEditing;
  bool unchanged = true;
  final bool isExpense;
  _ExpenseIncomeFormState({
    this.isEditing = true,
    this.refreshListener,
    this.transactionToBeEdited,
    this.unixDate,
    this.isExpense,
    this.expenseCategories = const [],
    this.incomeCategories = const [],
    this.currUserId,
  });
  bool init = false;
  bool _isExpense = true;
  final _amntController = TextEditingController();
  final _titleController = TextEditingController();
  var _title = "";
  var _groupValue = 1;
  int _category;
  var amount = IponTField();
  int _currAmount;
  List<DropdownMenuItem> categoriesWidgets = [];
  DBHelper _dbHelper = DBHelper();

  void _switchType(int groupValue) {
    switch (groupValue) {
      case 1:
        _category = 1;
        _isExpense = true;
        break;
      case 2:
        _category = 1;
        _isExpense = false;
        break;
    }
    _groupValue = groupValue;
    unchanged = true;
    _populateCategoryDropdown();
  }

  void _selectCategory(int id) {
    setState(() {
      _category = id;
    });
  }

  void _changeTitle() {
    if (isEditing) {
      switch (_groupValue) {
        case 1:
          _title = "Edit Expense";
          break;
        case 2:
          _title = "Edit Income";
          break;
      }
    } else if (!isEditing) {
      switch (_groupValue) {
        case 1:
          _title = "Add Expense";
          break;
        case 2:
          _title = "Add Income";
          break;
      }
    }
    setState(() {
      unchanged = false;
    });
  }

  bool _validAmount() {
    try {
      if ((double.parse(_amntController.text) * 100) % 1 != 0) throw Exception;
      setState(() {
        _currAmount = (double.parse(_amntController.text) * 100).truncate();
      });
      return true;
    } catch (Exception) {
      _currAmount = null;
      return false;
    }
  }

  bool _hasEmptyFields() {
    return (_amntController.text.trim() == "" ||
        _titleController.text.trim() == "");
  }

  void _addTransaction(
      BuildContext context, IncomeExpense transaction, bool isExpense) async {
    transaction.setUserId(currUserId);
    await _dbHelper.add(transaction, isExpense: isExpense);
    refreshListener();
    Navigator.of(context).pop();
  }

  void _updateTransaction(BuildContext context, IncomeExpense transaction,
      IncomeExpense newData, bool isExpense) async {
    newData.setUserId(currUserId);
    await _dbHelper.updateTransaction(
      isExpense,
      transaction,
      newData,
    );
    refreshListener();
    Navigator.of(context).pop();
  }

  void _deleteTransaction(BuildContext context, int id, bool isExpense) async {
    await _dbHelper.deleteTransactions(isExpense, id: id);
    refreshListener();
    Navigator.of(context).pop();
  }

  void _attemptSave(BuildContext context) {
    if (_hasEmptyFields()) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all the fields."),
        ),
      );
    } else if (!_validAmount()) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Please enter a valid amount. (2 decimal places, no special characters)"),
        ),
      );
    } else {
      IncomeExpense transaction = IncomeExpense(
          _category, -1, _titleController.text, _currAmount, unixDate);
      if (!isEditing) {
        _addTransaction(
            context, transaction, (isExpense != null) ? isExpense : _isExpense);
      } else {
        IncomeExpense update = IncomeExpense(
            transactionToBeEdited.categoryId,
            transactionToBeEdited.userId,
            _titleController.text,
            _currAmount,
            transactionToBeEdited.unixEntryDate);
        _updateTransaction(context, transactionToBeEdited, update,
            (isExpense != null) ? isExpense : _isExpense);
      }
      refreshListener();
    }
  }

  void _populateCategoryDropdown() {
    categoriesWidgets = [];
    for (Category category in ((isExpense != null) ? isExpense : _isExpense)
        ? expenseCategories
        : incomeCategories) {
      categoriesWidgets.add(DropdownMenuItem(
        value: category.id,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: IponColors.blue),
              child: ((isExpense != null) ? isExpense : _isExpense)
                  ? ExpenseIconList.icons[category.iconIndex]
                  : IncomeIconList.icons[category.iconIndex],
            ),
            Text(
                "${category.name.substring(0, 1).toUpperCase()}${category.name.substring(1)}"),
          ],
        ),
      ));
    }
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amntController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (categoriesWidgets.isEmpty) {
      _populateCategoryDropdown();
    }
    if (transactionToBeEdited != null && !init) {
      print("HELLO I'M TRYING MY BEST");
      print("isExpense IS $isExpense");
      setState(() {
        _amntController.text = "${transactionToBeEdited.amount / 100}";
        _category = transactionToBeEdited.categoryId;
        _titleController.text = transactionToBeEdited.name;
        _groupValue = ((isExpense != null) ? isExpense : _isExpense) ? 1 : 2;
        _switchType(_groupValue);
        init = true;
      });
    }
    amount = IponTField(
      prefix: Text("₱ "),
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ),
      margin: EdgeInsets.only(
        top: 50,
        bottom: 5,
      ),
      controller: _amntController,
      label: "Amount",
    );
    if (unchanged) {
      _changeTitle();
    }
    var height = MediaQuery.of(context).size.height;
    return ScaffoldWithBG(
      body: Builder(
        builder: (context) {
          return ListView(
            children: [
              Stack(children: [
                Container(
                  margin: EdgeInsets.only(top: 150),
                  width: double.infinity,
                  height: (height * 0.773) - 50,
                  color: IponColors.white,
                ),
                HomeBlock(
                  _title,
                  margin: EdgeInsets.only(
                    bottom: 20,
                    top: 100,
                  ),
                  rows: [
                    amount,
                    IponTField(
                      keyboardType: TextInputType.name,
                      margin: EdgeInsets.only(
                        top: 5,
                        bottom: 20,
                      ),
                      controller: _titleController,
                      label: "Descriptive Title",
                    ),
                    (!isEditing) ? IponCheckBoxes(_switchType) : Container(),
                    (transactionToBeEdited == null)
                        ? DropdownButton(
                            hint: Text("Category"),
                            value: _category,
                            items: [...categoriesWidgets],
                            onChanged: (value) => _selectCategory(value))
                        : Container(),
                    Container(
                      height: height * 0.15,
                      width: 1,
                    ),
                    SizedButton(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                      action: () {
                        _attemptSave(context);
                        print(
                            "AMOUNT: ${_amntController.text.replaceAll(" ", "")}");
                        print("TITLE: ${_titleController.text}");
                        print("Expense? : $_isExpense");
                      },
                      alignment: Alignment.center,
                      color: IponColors.blue,
                      height: 50,
                      width: 150,
                    ),
                    SizedButton(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        (isEditing) ? "Delete" : "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                      action: (isEditing)
                          ? () => _deleteTransaction(
                              context,
                              transactionToBeEdited.id,
                              (isExpense != null) ? isExpense : _isExpense)
                          : () => Navigator.of(context).pop(),
                      alignment: Alignment.center,
                      color: Colors.redAccent,
                      height: 50,
                      width: 150,
                    ),
                  ],
                ),
              ]),
            ],
          );
        },
      ),
    );
  }
}
