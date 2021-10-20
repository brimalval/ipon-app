import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project/models/category.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/graphs/graph_w_breakdown.dart';
import 'package:project/ui/mainmenu/ReportRow.dart';
import 'package:project/ui/pages/expinc_list.dart';
import 'package:project/util/DBHelper.dart';

class Graphsv2 extends StatefulWidget {
  final int currUserId;
  final List<Category> incomeCategories;
  final List<Map<String, dynamic>> monthlyIncome;
  final List<Map<String, dynamic>> totalIncome;

  final List<Category> expenseCategories;
  final List<Map<String, dynamic>> monthlyExpense;
  final List<Map<String, dynamic>> totalExpense;
  final Function refreshListener;
  Graphsv2({
    this.monthlyExpense = const [],
    this.totalExpense = const [],
    this.monthlyIncome = const [],
    this.totalIncome = const [],
    this.incomeCategories,
    this.expenseCategories,
    this.currUserId,
    this.refreshListener,
  });
  @override
  _Graphsv2State createState() => _Graphsv2State(
        monthlyExpense: monthlyExpense,
        totalExpense: totalExpense,
        monthlyIncome: monthlyIncome,
        totalIncome: totalIncome,
        incomeCategories: incomeCategories,
        expenseCategories: expenseCategories,
        currUserId: currUserId,
        refreshListener: refreshListener,
      );
}

class _Graphsv2State extends State<Graphsv2> {
  bool init = false;
  final List<Category> incomeCategories;
  List<Map<String, dynamic>> monthlyIncome;
  List<Map<String, dynamic>> totalIncome;
  final int currUserId;
  Map<String, double> monthlyIncomeData = {};
  Map<String, double> totalIncomeData = {};
  Map<String, double> monthlyExpenseData = {};
  Map<String, double> totalExpenseData = {};
  final Function refreshListener;

  final List<Category> expenseCategories;
  List<Map<String, dynamic>> monthlyExpense;
  List<Map<String, dynamic>> totalExpense;

  _Graphsv2State({
    this.monthlyExpense = const [],
    this.totalExpense = const [],
    this.monthlyIncome = const [],
    this.totalIncome = const [],
    this.incomeCategories,
    this.expenseCategories,
    this.currUserId,
    this.refreshListener,
  });

  List<ReportRow> monthlyExpenseRows = [];
  List<ReportRow> monthlyIncomeRows = [];
  List<ReportRow> totalExpenseRows = [];
  List<ReportRow> totalIncomeRows = [];
  DBHelper _dbHelper = DBHelper();

  void _openTransactList(BuildContext context, String title, bool isExpenses,
      bool monthly, int catId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TransactionList(
              currUserId,
              title,
              isExpenses,
              expenseCategories: expenseCategories,
              incomeCategories: incomeCategories,
              monthly: monthly,
              refreshListener: reloadNewData,
              catId: catId,
            )));
  }

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

  void reloadNewData() async{
    String monthExpenseQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount 
           FROM expenses e LEFT JOIN expense_categories ec ON e.category_id = ec.id
           WHERE e.user_id = $currUserId AND unix_entry_date >= ${_beginningOfMonth(8)}
           AND unix_entry_date <= ${_endOfMonth(8)} GROUP BY ec.id
        ''';
    String monthIncomeQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount 
           FROM incomes e LEFT JOIN income_categories ec ON e.category_id = ec.id
           WHERE e.user_id = $currUserId AND unix_entry_date >= ${_beginningOfMonth(8)}
           AND unix_entry_date <= ${_endOfMonth(8)} GROUP BY ec.id
        ''';
    String totalExpenseQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount 
           FROM expenses e LEFT JOIN expense_categories ec ON e.category_id = ec.id
           WHERE e.user_id = $currUserId GROUP BY ec.id
        ''';
    String totalIncomeQuery =
        '''SELECT ec.id AS cat_id, ec.name AS cat_name, SUM(amount) AS t_amount
           FROM incomes e LEFT JOIN income_categories ec ON e.category_id = ec.id
           WHERE e.user_id = $currUserId GROUP BY ec.id
        ''';
    monthlyExpense = await _dbHelper.rawQuery(monthExpenseQuery);
    monthlyIncome = await _dbHelper.rawQuery(monthIncomeQuery);
    totalExpense = await _dbHelper.rawQuery(totalExpenseQuery);
    totalIncome = await _dbHelper.rawQuery(totalIncomeQuery);
    monthlyExpenseRows = [];
    monthlyIncomeRows = [];
    totalExpenseRows = [];
    totalIncomeRows = [];
    setState((){});
    _initGraphMaps();
  }

  void _initGraphMaps() {
    setState(() {
      for (Map<String, dynamic> row in monthlyExpense) {
        monthlyExpenseData[row['cat_name']] = row['t_amount'] / 100;
        monthlyExpenseRows.add(
          ReportRow(
            row['cat_name'],
            "${(row['t_amount'] / 100)}",
            action: () {
              _openTransactList(
                  context,
                  "Monthly Expenses for Category ${row['cat_name']}",
                  true,
                  true,
                  row['cat_id']);
            },
          ),
        );
      }
      for (Map<String, dynamic> row in monthlyIncome) {
        monthlyIncomeData[row['cat_name']] = row['t_amount'] / 100;
        monthlyIncomeRows.add(
          ReportRow(
            row['cat_name'],
            "${(row['t_amount'] / 100)}",
            action: () {
              _openTransactList(
                  context,
                  "Monthly Incomes for Category ${row['cat_name']}",
                  false,
                  true,
                  row['cat_id']);
            },
          ),
        );
      }
      for (Map<String, dynamic> row in totalExpense) {
        totalExpenseData[row['cat_name']] = row['t_amount'] / 100;
        totalExpenseRows.add(
          ReportRow(
            row['cat_name'],
            "${(row['t_amount'] / 100)}",
            action: () {
              _openTransactList(
                  context,
                  "Total Expenses for Category ${row['cat_name']}",
                  true,
                  false,
                  row['cat_id']);
            },
          ),
        );
      }
      for (Map<String, dynamic> row in totalIncome) {
        totalIncomeData[row['cat_name']] = row['t_amount'] / 100;
        totalIncomeRows.add(
          ReportRow(
            row['cat_name'],
            "${(row['t_amount'] / 100)}",
            action: () {
              _openTransactList(
                context,
                "Monthly Incomes for Category ${row['cat_name']}",
                false,
                false,
                row['cat_id'],
              );
            },
          ),
        );
      }
    });
    refreshListener();
  }

  String padDateUnit(String str) {
    return str.padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    var currMonth = DateTime.now().month;
    var lastDay = DateTime.fromMillisecondsSinceEpoch(
            DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1)
                    .millisecondsSinceEpoch -
                (8 * 3600000) -
                86400000)
        .day;
    if (!init) {
      print("FDAKLSFDJKA");
      init = true;
      _initGraphMaps();
    }
    return ScaffoldWithBG(
      body: ListView(
        children: [
          GraphBreakdown(
            monthlyExpenseData,
            monthlyExpenseRows,
            "Monthly Expenses (${padDateUnit(currMonth.toString())}/01 - ${padDateUnit((currMonth + 0).toString())}/${padDateUnit(lastDay.toString())})",
          ),
          GraphBreakdown(
            monthlyIncomeData,
            monthlyIncomeRows,
            "Monthly Income (${padDateUnit(DateTime.now().month.toString())}/01 - ${DateTime.now().month}/${padDateUnit(lastDay.toString())})",
          ),
          GraphBreakdown(
            totalExpenseData,
            totalExpenseRows,
            "Total Expense",
          ),
          GraphBreakdown(
            totalIncomeData,
            totalIncomeRows,
            "Total Income",
          ),
        ],
      ),
    );
  }
}
