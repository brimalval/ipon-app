import 'package:flutter/material.dart';
import 'package:project/iconlist.dart';
import 'package:project/models/category.dart';
import 'package:project/palette.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/categories/category_btn.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/categories/category_crud.dart';
import 'package:project/util/DBHelper.dart';

class Categories extends StatefulWidget {
  final int currUser;
  Categories({this.currUser});
  @override
  _CategoriesState createState() => _CategoriesState(currUser: currUser);
}

class _CategoriesState extends State<Categories> {
  final int currUser;
  _CategoriesState({this.currUser});
  DBHelper _dbHelper = DBHelper();
  List<Widget> _expenseCatRows = [];
  List<Widget> _incomeCatRows = [];
  void _addPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryForm(
          addListener: _addCat,
          currUser: currUser,
        ),
      ),
    );
  }

  void _addCat(Category data, bool isExpense) async {
    await _dbHelper.add(data, isExpense: isExpense);
    _loadCategories();
  }

  void _updateCat(bool isExpense, Category category, Category newData) async {
    await _dbHelper.updateCategory(isExpense, category, newData);
    _loadCategories();
  }

  void _deleteCat(bool isExpense, int id) async {
    await _dbHelper.deleteCategories(isExpense, id: id);
    _loadCategories();
  }

  void _editPage(Category category) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CategoryForm(
              categoryToBeEdited: category,
              isEditing: true,
              updateListener: _updateCat,
              deleteListener: _deleteCat,
              currUser: currUser,
            )));
  }

  void _defaultCategory(Category category) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CategoryForm(
              categoryToBeEdited: category,
              isDefault: true,
            )));
  }

  void _loadCategories({int columnCount = 4}) async {
    _expenseCatRows = [];
    _incomeCatRows = [];
    List<Category> expenseCategories =
        await _dbHelper.getCategories(true, userId: currUser);
    List<Category> incomeCategories =
        await _dbHelper.getCategories(false, userId: currUser);
    print("CATEGORIES EXPENSE COUNT: ${expenseCategories.length}");
    print("CATEGORIES INCOME COUNT: ${incomeCategories.length}");
    int rowLimiter = 0;
    List<LblButton> row = [];
    for (Category expenseCategory in expenseCategories) {
      if (rowLimiter < columnCount) {
        row.add(
          LblButton(
            ExpenseIconList.icons[expenseCategory.iconIndex],
            expenseCategory.name,
            onPressed: (expenseCategory.isDefault)
                ? () => _defaultCategory(expenseCategory)
                : () => _editPage(expenseCategory),
          ),
        );
        print("CURRENT ROW LENGTH: ${row.length}");
        rowLimiter++;
      } else {
        rowLimiter = 1;
        _expenseCatRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          ),
        );
        row = <LblButton>[];
        row.add(
          LblButton(
            ExpenseIconList.icons[expenseCategory.iconIndex],
            "${expenseCategory.name.substring(0, 1).toUpperCase()}${expenseCategory.name.substring(1)}",
            onPressed: (expenseCategory.isDefault)
                ? () => _defaultCategory(expenseCategory)
                : () => _editPage(expenseCategory),
          ),
        );
      }
    }
    if (row.isNotEmpty) {
      _expenseCatRows.add(
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          ),
        ),
      );
      row = <LblButton>[];
    }
    //---INCOME ROWS---

    rowLimiter = 0;
    row = [];
    for (Category incomeCategory in incomeCategories) {
      if (rowLimiter < columnCount) {
        row.add(
          LblButton(
            IncomeIconList.icons[incomeCategory.iconIndex],
            incomeCategory.name,
            onPressed: (incomeCategory.isDefault)
                ? () => _defaultCategory(incomeCategory)
                : () => _editPage(incomeCategory),
          ),
        );
        print("CURRENT ROW LENGTH: ${row.length}");
        rowLimiter++;
      } else {
        rowLimiter = 1;
        _incomeCatRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          ),
        );
        row = <LblButton>[];
        row.add(
          LblButton(
            IncomeIconList.icons[incomeCategory.iconIndex],
            "${incomeCategory.name.substring(0, 1).toUpperCase()}${incomeCategory.name.substring(1)}",
            onPressed: (incomeCategory.isDefault)
                ? () => _defaultCategory(incomeCategory)
                : () => _editPage(incomeCategory),
          ),
        );
      }
    }
    if (row.isNotEmpty) {
      _incomeCatRows.add(
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          ),
        ),
      );
      row = <LblButton>[];
    }
    //-----------------
    print("EXPENSE ROWS LENGTH : ${_expenseCatRows.length}");
    print("INCOME ROWS LENGTH : ${_incomeCatRows.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_expenseCatRows.isEmpty) {
      _loadCategories(columnCount: 4);
    }
    return ScaffoldWithBG(
      actions: [
        FloatingActionButton(
          backgroundColor: IponColors.darkblue,
          child: Icon(
            Icons.add,
            color: IponColors.white,
          ),
          onPressed: () => _addPage(),
        ),
      ],
      body: ListView(
        children: [
          HomeBlock(
            "Expense Categories",
            margin: EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            rows: [
              ..._expenseCatRows,
            ],
          ),
          HomeBlock(
            "Income Categories",
            rows: [
              ..._incomeCatRows,
            ],
          ),
        ],
      ),
    );
  }
}
