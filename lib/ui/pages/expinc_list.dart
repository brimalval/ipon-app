import 'package:flutter/material.dart';
import 'package:project/models/category.dart';
import 'package:project/models/expense.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/mainmenu/ReportRow.dart';
import 'package:project/ui/mainmenu/expinc_crud.dart';
import 'package:project/util/DBHelper.dart';

class TransactionList extends StatefulWidget {
  final int _currUserId;
  final String title;
  final Function refreshListener;
  final List<Category> incomeCategories;
  final List<Category> expenseCategories;
  final bool isExpenses;
  final int catId;
  final bool monthly;
  TransactionList(this._currUserId, this.title, this.isExpenses,
      {this.refreshListener,
      this.incomeCategories,
      this.expenseCategories,
      this.catId,
      this.monthly}){
        print("PASSED $_currUserId TO TRANSACTIONLIST");
      }
  @override
  _TransactionListState createState() =>
      _TransactionListState(_currUserId, title, isExpenses,
          refreshListener: refreshListener,
          monthly: monthly,
          catId: catId,
          expenseCategories: expenseCategories,
          incomeCategories: incomeCategories);
}

class _TransactionListState extends State<TransactionList> {
  List<IncomeExpense> transactions;
  DBHelper _dbHelper = DBHelper();
  final Function refreshListener;
  final List<Category> incomeCategories;
  final List<Category> expenseCategories;
  final String _title;
  final int _currUserId;
  final bool _isExpenses;
  final bool monthly;
  final int catId;
  bool init = false;
  _TransactionListState(this._currUserId, this._title, this._isExpenses,
      {this.refreshListener,
      this.incomeCategories,
      this.expenseCategories,
      this.catId,
      this.monthly = true});
  List<ReportRow> rows = [];

  int _beginningOfMonth(int gmtOffset) {
    return (DateTime.utc(DateTime.now().year, DateTime.now().month)
                .millisecondsSinceEpoch -
            (gmtOffset * 3600000)) ~/
        1000;
  }

  int _endOfMonth(int gmtOffset) {
    return (DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1)
                .millisecondsSinceEpoch -
            (gmtOffset * 3600000) -
            86400001) ~/
        1000;
  }

  void _loadTransacts(int catId) async {
    rows = [];
    transactions = (monthly)
        ? await _dbHelper.getTransactsBetDates(
            _isExpenses, _beginningOfMonth(8), _endOfMonth(8), _currUserId, catId: catId)
        : await _dbHelper.getTransactions(_isExpenses, userId: _currUserId, catId: catId);
    setState(() {});
  }

  void refresh() {
    refreshListener();
    _loadTransacts(catId);
  }

  @override
  Widget build(BuildContext context) {
    if (transactions == null || !init) {
      _loadTransacts(catId);
    }
    for (IncomeExpense ie in transactions) {
      rows.add(ReportRow(
        ie.name,
        "${ie.amount/100}",
        action: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExpenseIncomeForm(
                  currUserId: _currUserId,
                  transactionToBeEdited: ie,
                  isEditing: true,
                  expenseCategories: expenseCategories,
                  incomeCategories: incomeCategories,
                  unixDate: ie.unixEntryDate,
                  refreshListener: refresh,
                  isExpense: _isExpenses,
                ))),
      ));
    }
    return ScaffoldWithBG(
      showDrawer: false,
      body: ListView(
        children: [
          Container(margin: EdgeInsets.only(top: 75)),
          HomeBlock(
            _title,
            rows: [...rows],
          ),
        ],
      ),
    );
  }
}
