import 'package:flutter/material.dart';
import 'package:project/models/expense.dart';
import 'package:project/models/user.dart';
import 'package:project/models/category.dart';
import 'package:project/palette.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/mainmenu/ReportRow.dart';
import 'package:project/ui/mainmenu/expinc_crud.dart';
import 'package:project/ui/pages/Categories.dart';
import 'package:project/ui/pages/Graphs.dart';
import 'package:project/ui/pages/Graphsv2.dart';
import 'package:project/ui/pages/Login.dart';
import 'package:project/ui/pages/expinc_list.dart';
import 'package:project/util/DBHelper.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DBHelper _dbHelper = DBHelper();
  DateTime _dateTime;
  User _currUser;
  double _totalExpense;
  double _totalIncome;
  double _dailyExpense;
  double _dailyIncome;
  List<Category> _incomeCategories = [];
  List<Category> _expenseCategories = [];

  void _populateCategories() async {
    _expenseCategories =
        await _dbHelper.getCategories(true, userId: _currUser.id);
    _incomeCategories =
        await _dbHelper.getCategories(false, userId: _currUser.id);
    setState(() {});
  }

  void _printCategories() async {
    print("EXPENSES: ${(await _dbHelper.getCategories(true)).length}");
    print("INCOME: ${(await _dbHelper.getCategories(false)).length}");
  }

  void refresh() {
    _populateCategories();
    _getDailyTransactions();
    _getTotalTransactions();
    setState(() {});
  }

  void _showExpenseIncomeForm(BuildContext context) {
    refresh();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExpenseIncomeForm(
              isEditing: false,
              refreshListener: refresh,
              unixDate: _dateTime.millisecondsSinceEpoch ~/ 1000,
              expenseCategories: _expenseCategories,
              incomeCategories: _incomeCategories,
              currUserId: _currUser.id,
            )));
  }

  void _logout() {
    _currUser = null;
    refresh();
  }

  void _login(User user) {
    _currUser = user;
    refresh();
  }

  void _getTotalTransactions() async {
    _totalIncome = 0;
    _totalExpense = 0;
    var dExpense = await _dbHelper.rawQuery(
        '''SELECT SUM(amount) AS sum FROM expenses WHERE user_id = ${_currUser.id}''');
    var dIncome = await _dbHelper.rawQuery(
        '''SELECT SUM(amount) AS sum FROM incomes WHERE user_id = ${_currUser.id}''');
    _totalIncome = ((dIncome[0]['sum'] != null) ? dIncome[0]['sum'] : 0) / 100;
    _totalExpense =
        ((dExpense[0]['sum'] != null) ? dExpense[0]['sum'] : 0) / 100;
    print("TOTALI: $_totalIncome");
    print("TOTALE: $_totalExpense");
    setState(() {});
  }

  void _getDailyTransactions() async {
    _dailyIncome = 0;
    _dailyExpense = 0;
    int unixDate = _dateTime.millisecondsSinceEpoch ~/ 1000;
    var dExpense = await _dbHelper.rawQuery(
        '''SELECT SUM(amount) AS sum FROM expenses WHERE unix_entry_date == $unixDate AND user_id = ${_currUser.id}''');
    var dIncome = await _dbHelper.rawQuery(
        '''SELECT SUM(amount) AS sum FROM incomes WHERE unix_entry_date == $unixDate AND user_id = ${_currUser.id}''');
    _dailyIncome = ((dIncome[0]['sum'] != null) ? dIncome[0]['sum'] : 0) / 100;
    _dailyExpense =
        ((dExpense[0]['sum'] != null) ? dExpense[0]['sum'] : 0) / 100;
    print("DAILYINCOME: $_dailyIncome");
    print("DAILYEXPENSE: $_dailyExpense");
    setState(() {});
  }

  void _openCategories(BuildContext context) {
    Navigator.of(context).pop();
    if (_currUser != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Categories(
                currUser: _currUser.id,
              )));
    }
    _expenseCategories = [];
    _incomeCategories = [];
  }

  /*void _openGraphs(BuildContext context) async {
    refresh();
    List<Map<String, dynamic>> totalExpense =
        await _dbHelper.getTransactionsJoinedCategories(
      true,
      userId: _currUser.id,
    );
    List<Map<String, dynamic>> totalIncome =
        await _dbHelper.getTransactionsJoinedCategories(
      false,
      userId: _currUser.id,
    );
    List<Map<String, dynamic>> monthlyExpense =
        await _dbHelper.getTransactionsJoinedCategories(
      true,
      userId: _currUser.id,
      unixDateStart: _beginningOfMonth(8),
      unixDateEnd: _endOfMonth(8),
    );
    print("MONTHLY EXPENSE LIST LENGTH FROM MAIN: ${monthlyExpense.length}");
    List<Map<String, dynamic>> monthlyIncome =
        await _dbHelper.getTransactionsJoinedCategories(
      false,
      userId: _currUser.id,
      unixDateStart: _beginningOfMonth(8),
      unixDateEnd: _endOfMonth(8),
    );
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Graphs(
              currUserId: _currUser.id,
              expenseCategories: _expenseCategories,
              incomeCategories: _incomeCategories,
              monthlyExpense: monthlyExpense,
              monthlyIncome: monthlyIncome,
              totalExpense: totalExpense,
              totalIncome: totalIncome,
              refreshListener: refresh,
            )));
  }*/

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

  void _openGraphs(BuildContext context) async {
    refresh();
    String monthExpenseQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount 
           FROM expenses e LEFT JOIN expense_categories ec ON e.category_id = ec.id
           WHERE e.user_id = ${_currUser.id} AND unix_entry_date >= ${_beginningOfMonth(8)}
           AND unix_entry_date <= ${_endOfMonth(8)} GROUP BY ec.id
        ''';
    String monthIncomeQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount 
           FROM incomes e LEFT JOIN income_categories ec ON e.category_id = ec.id
           WHERE e.user_id = ${_currUser.id} AND unix_entry_date >= ${_beginningOfMonth(8)}
           AND unix_entry_date <= ${_endOfMonth(8)} GROUP BY ec.id
        ''';
    String totalExpenseQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount 
           FROM expenses e LEFT JOIN expense_categories ec ON e.category_id = ec.id
           WHERE e.user_id = ${_currUser.id} GROUP BY ec.id
        ''';
    String totalIncomeQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount
           FROM incomes e LEFT JOIN income_categories ec ON e.category_id = ec.id
           WHERE e.user_id = ${_currUser.id} GROUP BY ec.id
        ''';
    List<Map<String, dynamic>> monthlyExpenses = await _dbHelper.rawQuery(monthExpenseQuery);
    List<Map<String, dynamic>> monthlyIncome = await _dbHelper.rawQuery(monthIncomeQuery);
    List<Map<String, dynamic>> totalExpenses = await _dbHelper.rawQuery(totalExpenseQuery);
    List<Map<String, dynamic>> totalIncome = await _dbHelper.rawQuery(totalIncomeQuery);
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Graphsv2(
      currUserId: _currUser.id,
      expenseCategories: _expenseCategories,
      incomeCategories: _incomeCategories,
      monthlyExpense: monthlyExpenses,
      monthlyIncome: monthlyIncome,
      totalExpense: totalExpenses,
      totalIncome: totalIncome,
      refreshListener: refresh,
    )));
  }

  @override
  Widget build(BuildContext context) {
    _printCategories();
    if (_dateTime == null) {
      setState(() {
        _dateTime = DateTime.now();
        _dateTime =
            DateTime.utc(_dateTime.year, _dateTime.month, _dateTime.day);
        //replace 8 with the number of hours offset of your timezone from UTC
        //Philippines: GMT +8
        _dateTime = DateTime.fromMillisecondsSinceEpoch(
            _dateTime.millisecondsSinceEpoch - (8 * 3600000));
      });
    }
    print("INITIAL DATETIME: ${_dateTime.millisecondsSinceEpoch}");
    if ((_totalIncome == null || _totalExpense == null) && _currUser != null) {
      _getTotalTransactions();
    }
    if ((_dailyExpense == null || _dailyIncome == null) && _currUser != null) {
      _getDailyTransactions();
    }
    return MaterialApp(
      theme: ThemeData(
        accentColor: IponColors.coolblue,
        primaryColor: IponColors.blue,
        fontFamily: "Century Gothics",
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home: Builder(
        builder: (BuildContext context) {
          return (_currUser != null)
              ? ScaffoldWithBG(
                  graphAction: () => _openGraphs(context),
                  categoryAction: () => _openCategories(context),
                  firstName: _currUser.firstName,
                  lastName: _currUser.lastName,
                  logOutAction: _logout,
                  showDrawer: true,
                  body: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.only(
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white70,
                        ),
                        child: CalendarDatePicker(
                          initialDate: _dateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          onDateChanged: (date) {
                            _dateTime = date;
                            _getDailyTransactions();
                          },
                        ),
                      ),
                      HomeBlock(
                        "Daily Report for ${_dateTime.month.toString().padLeft(2, '0')}/${_dateTime.day.toString().padLeft(2, '0')}/${_dateTime.year}",
                        rows: [
                          ReportRow("Expenses", "$_dailyExpense"),
                          ReportRow("Income", "$_dailyIncome"),
                        ],
                        addAction: () {
                          _showExpenseIncomeForm(context);
                        },
                      ),
                      HomeBlock(
                        "Total Savings",
                        rows: [
                          ReportRow(
                            "Total Net Income",
                            "${_totalIncome - _totalExpense}",
                          ),
                          ReportRow(
                            "Daily Net Income",
                            "${_dailyIncome - _dailyExpense}",
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Login(
                  loginListener: _login,
                );
        },
      ),
    );
  }
}

/* 
ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.only(
                        bottom: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white70,
                      ),
                      child: CalendarDatePicker(
                        initialDate: _dateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        onDateChanged: (date) {
                          setState(() {
                            _dateTime = date;
                          });
                        },
                      ),
                    ),
                    HomeBlock(
                      "Daily Report for ${_dateTime.month.toString().padLeft(2, '0')}/${_dateTime.day.toString().padLeft(2, '0')}/${_dateTime.year}",
                      rows: [
                        ReportRow("Expenses", "5485"),
                        ReportRow("Income", "123"),
                      ],
                      addAction: () {},
                    ),
                    HomeBlock(
                      "Monthly Savings",
                      rows: [
                        ReportRow("Savings", "4343"),
                      ],
                    ),
                  ],
                ),
*/
