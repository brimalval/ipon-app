import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project/models/category.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/graphs/graph_w_breakdown.dart';
import 'package:project/ui/mainmenu/ReportRow.dart';
import 'package:project/ui/pages/expinc_list.dart';

class Graphs extends StatefulWidget {
  final int currUserId;
  final List<Category> incomeCategories;
  final List<Map<String, dynamic>> monthlyIncome;
  final List<Map<String, dynamic>> totalIncome;

  final List<Category> expenseCategories;
  final List<Map<String, dynamic>> monthlyExpense;
  final List<Map<String, dynamic>> totalExpense;
  final Function refreshListener;
  Graphs({
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
  _GraphsState createState() => _GraphsState(
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

class _GraphsState extends State<Graphs> {
  final List<Category> incomeCategories;
  final List<Map<String, dynamic>> monthlyIncome;
  final List<Map<String, dynamic>> totalIncome;
  final int currUserId;
  Map<String, double> monthlyIncomeData = {};
  Map<String, double> totalIncomeData = {};
  final Function refreshListener;

  final List<Category> expenseCategories;
  final List<Map<String, dynamic>> monthlyExpense;
  final List<Map<String, dynamic>> totalExpense;
  Map<String, double> monthlyExpenseData = {};
  Map<String, double> totalExpenseData = {};

  _GraphsState({
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

  void _openTransactList(
      BuildContext context, String title, bool isExpenses, bool monthly) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TransactionList(
              currUserId,
              title,
              isExpenses,
              expenseCategories: expenseCategories,
              incomeCategories: incomeCategories,
              monthly: monthly,
              refreshListener: _initGraphMaps,
            )));
  }

  void _initGraphMaps() {
    monthlyExpenseRows.clear();
    monthlyIncomeRows.clear();
    totalExpenseRows.clear();
    totalIncomeRows.clear();
    print("NUMBER OF monthly expenses: ${monthlyExpense.length}");
    for (Category c in incomeCategories) {
      print("ADDING ${c.name} KEY TO INCOME");
      monthlyIncomeData[c.name] = 0;
      totalIncomeData[c.name] = 0;
    }
    for (Category c in expenseCategories) {
      print("ADDING ${c.name} KEY TO EXPENSES");
      monthlyExpenseData[c.name] = 0;
      totalExpenseData[c.name] = 0;
    }
    for (Map<String, dynamic> row in monthlyExpense) {
      print(
          "ID: ${row['t_id']} ${monthlyExpenseData[row['c_name']]} + (${row['amount']}) -");
      monthlyExpenseData[row['c_name']] += (row['amount'] / 100);
    }
    for (Map<String, dynamic> row in totalExpense) {
      totalExpenseData[row['c_name']] += (row['amount'] / 100);
    }

    for (Map<String, dynamic> row in monthlyIncome) {
      print("ID: ${row['t_id']} ${row['c_name']} + (${row['amount']})");
      monthlyIncomeData[row['c_name']] += (row['amount'] / 100);
    }
    for (Map<String, dynamic> row in totalIncome) {
      totalIncomeData[row['c_name']] += (row['amount'] / 100);
    }
    monthlyExpenseData.forEach((key, value) {
      monthlyExpenseRows.add(ReportRow(
        "${key.substring(0, 1).toUpperCase()}${key.substring(1)}",
        "$value",
        action: () =>
            _openTransactList(context, "Monthly Expenses", true, true),
      ));
    });
    monthlyIncomeData.forEach((key, value) {
      monthlyIncomeRows.add(ReportRow(
        "${key.substring(0, 1).toUpperCase()}${key.substring(1)}",
        "$value",
        action: () => _openTransactList(context, "Monthly Income", false, true),
      ));
    });
    totalExpenseData.forEach((key, value) {
      totalExpenseRows.add(
        ReportRow(
            "${key.substring(0, 1).toUpperCase()}${key.substring(1)}", "$value",
            action: () =>
                _openTransactList(context, "All Expenses", true, false,)),
      );
    });
    totalIncomeData.forEach((key, value) {
      totalIncomeRows.add(ReportRow(
        "${key.substring(0, 1).toUpperCase()}${key.substring(1)}",
        "$value",
        action: () => _openTransactList(context, "All Income", false, false),
      ));
    });
    setState(() {});
  }

  bool init = false;

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
    if (monthlyIncomeData.isEmpty) {
      print("FDAKLSFDJKA");
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
