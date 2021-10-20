import 'package:project/iconlist.dart';
import 'package:project/models/category.dart';
import 'package:project/models/expense.dart';
import 'package:project/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DBHelper {
  static DBHelper _dbHelper;
  static Database _db;
  DBHelper._createInstance();
  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._createInstance();
    }
    return _dbHelper;
  }

  Future<Database> initDB() async {
    /*
      Databases made:
      project.db - first version, only has users table
      projectv2.db - added categories, incomes, expenses
      projectv3.db - added fields to incomes and expenses
     */
    return openDatabase(
      join(await getDatabasesPath(), 'project_final_1.db'),
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name VARCHAR NOT NULL,
          last_name VARCHAR NOT NULL,
          email VARCHAR NOT NULL,
          user VARCHAR NOT NULL,
          pass VARCHAR NOT NULL
        );
        ''');
        db.execute('''
        CREATE TABLE incomes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          category_id INTEGER NOT NULL,
          unix_entry_date INTEGER NOT NULL,
          name VARCHAR NOT NULL,
          amount INTEGER NOT NULL
        );
        ''');
        db.execute('''
        CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          category_id INTEGER NOT NULL,
          unix_entry_date INTEGER NOT NULL,
          name VARCHAR NOT NULL,
          amount INTEGER NOT NULL
        );
        ''');
        db.execute('''
        CREATE TABLE expense_categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          icon_index INT NOT NULL,
          name VARCHAR NOT NULL,
          is_default INT NOT NULL
        );
        ''');
        db.execute('''
        CREATE TABLE income_categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          icon_index INT NOT NULL,
          name VARCHAR NOT NULL,
          is_default INT NOT NULL
        );
        ''');
        //Default categories
        db.execute(
            '''INSERT INTO expense_categories (icon_index, user_id, is_default,  name) VALUES (0, 0, 1, 'essentials')''');
        db.execute(
            '''INSERT INTO expense_categories (icon_index, user_id, is_default,  name) VALUES (1, 0, 1, 'data')''');
        db.execute(
            '''INSERT INTO expense_categories (icon_index, user_id, is_default,  name) VALUES (2, 0, 1, 'games')''');
        db.execute(
            '''INSERT INTO expense_categories (icon_index, user_id, is_default,  name) VALUES (3, 0, 1, 'electricity')''');
        db.execute(
            '''INSERT INTO expense_categories (icon_index, user_id, is_default,  name) VALUES (4, 0, 1, 'leisure')''');
        db.execute(
            '''INSERT INTO expense_categories (icon_index, user_id, is_default,  name) VALUES (5, 0, 1, 'others')''');

        db.execute(
            '''INSERT INTO income_categories (icon_index, user_id, is_default, name) VALUES (0, 0, 1, 'job')''');
        db.execute(
            '''INSERT INTO income_categories (icon_index, user_id, is_default, name) VALUES (1, 0, 1, 'allowance')''');
        db.execute(
            '''INSERT INTO income_categories (icon_index, user_id, is_default, name) VALUES (2, 0, 1, 'interest')''');
        db.execute(
            '''INSERT INTO income_categories (icon_index, user_id, is_default, name) VALUES (3, 0, 1, 'others')''');
      },
      version: 1,
    );
  }

  Future<Database> getDB() async {
    if (_db == null) {
      _db = await initDB();
    }
    return _db;
  }

  Future<List<User>> getUsers({int id}) async {
    var db = await getDB();
    List<Map<String, dynamic>> tbl;
    tbl = (id != null)
        ? await db.query('users', where: 'id = ?', whereArgs: [id])
        : await db.query('users');
    List<User> users = [];
    for (var row in tbl) {
      users.add(User.withMap(row));
    }
    return users;
  }

  Future<List<IncomeExpense>> getTransactions(bool expenses,
      {int userId, int catId}) async {
    var db = await getDB();
    List<Map<String, dynamic>> tbl;
    String whereSuffix1 = (catId != null) ? "category_id = $catId" : "";
    String whereSuffix2 = (catId != null) ? " AND category_id = $catId" : "";
    if (expenses) {
      (userId == null)
          ? tbl = await db.query('expenses', where: whereSuffix1)
          : tbl = await db
              .query('expenses', where: "user_id = ?$whereSuffix2", whereArgs: [userId]);
    } else {
      (userId == null)
          ? tbl = await db.query('incomes', where: whereSuffix1)
          : tbl = await db
              .query('incomes', where: "user_id = ?$whereSuffix2", whereArgs: [userId]);
    }
    List<IncomeExpense> transactions = [];
    for (var transaction in tbl) {
      transactions.add(IncomeExpense.withMap(transaction));
    }
    return transactions;
  }

  Future<List<IncomeExpense>> getTransactionsFromDate(
      int unixDate, bool expenses,
      {int userId}) async {
    var db = await getDB();
    List<Map<String, dynamic>> tbl;
    if (expenses) {
      (userId == null)
          ? tbl = await db.query('expenses',
              where: "unix_entry_date = ?", whereArgs: [unixDate])
          : tbl = await db.query('expenses',
              where: "user_id = ? AND unix_entry_date = ?",
              whereArgs: [userId, unixDate]);
    } else {
      (userId == null)
          ? tbl = await db.query('incomes',
              where: "unix_entry_date = ?", whereArgs: [unixDate])
          : tbl = await db.query('incomes',
              where: "user_id = ? AND unix_entry_date = ?",
              whereArgs: [userId, unixDate]);
    }
    List<IncomeExpense> transactions = [];
    for (var transaction in tbl) {
      transactions.add(IncomeExpense.withMap(transaction));
    }
    return transactions;
  }

  Future<List<Map<String, dynamic>>> getTransactionsJoinedCategories(
      bool expenses,
      {int userId,
      int unixDateStart,
      int unixDateEnd}) async {
    var db = await getDB();
    var tbl = (expenses) ? 'expenses' : 'incomes';
    var ctg = (expenses) ? 'expense_categories' : 'income_categories';
    String whereSuffix = (userId != null) ? " WHERE t.user_id = $userId" : "";
    String dateSuffix = (unixDateStart != null)
        ? " AND (unix_entry_date >= $unixDateStart AND unix_entry_date <= $unixDateEnd)"
        : "";
    List<Map<String, dynamic>> data;
    print('''SELECT t.id AS t_id, t.user_id AS t_user_id, unix_entry_date, 
        t.name AS t_name, amount, c.id AS c_id, c.user_id AS c_user_id, 
        icon_index, c.name AS c_name, is_default FROM $tbl t LEFT JOIN $ctg c ON t.category_id = c.id$whereSuffix$dateSuffix;''');
    data = await db.rawQuery(
        '''SELECT t.id AS t_id, t.user_id AS t_user_id, unix_entry_date, 
        t.name AS t_name, amount, c.id AS c_id, c.user_id AS c_user_id, 
        icon_index, c.name AS c_name, is_default FROM $tbl t LEFT JOIN $ctg c ON t.category_id = c.id$whereSuffix$dateSuffix;''');
    print("________RETURNED ${data.length} ROWS_________");
    return data;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async{
    var db = await getDB();
    return await db.rawQuery(query);
  }

  Future<List<IncomeExpense>> getTransactsBetDates(
      bool expenses, int unixStart, int unixEnd, int userId, {int catId}) async {
    var db = await getDB();
    String whereSuffix = (catId != null) ? " AND category_id = $catId" : "";
    var transactions = await db.query((expenses) ? 'expenses' : 'incomes',
        where: "user_id = ? AND unix_entry_date >= ? AND unix_entry_date <= ?$whereSuffix",
        whereArgs: [userId, unixStart, unixEnd]);
    List<IncomeExpense> r = [];
    for(Map<String, dynamic> data in transactions){
      IncomeExpense t = IncomeExpense.withMap(data);
      r.add(t);
    }
    return r;
  }

  Future<List<Category>> getCategories(bool expenses, {int userId}) async {
    var db = await getDB();
    List<Map<String, dynamic>> tbl;
    if (expenses) {
      (userId == null)
          ? tbl = await db.query('expense_categories')
          : tbl = await db.query('expense_categories',
              where: "user_id = ? OR is_default = 1", whereArgs: [userId]);
    } else {
      (userId == null)
          ? tbl = await db.query('income_categories')
          : tbl = await db.query('income_categories',
              where: "user_id = ? OR is_default = 1", whereArgs: [userId]);
    }
    List<Category> categories = [];
    for (var category in tbl) {
      Category x = Category.withMap(category);
      x.setIsExpense(expenses);
      categories.add(x);
    }
    return categories;
  }

  Future<int> add(dynamic data, {bool isExpense}) async {
    var db = await getDB();
    if (data.runtimeType == User) {
      return await db.insert('users', data.toMap());
    } else if (data.runtimeType == IncomeExpense) {
      return (isExpense)
          ? await db.insert('expenses', data.toMap())
          : await db.insert('incomes', data.toMap());
    } else if (data.runtimeType == Category) {
      return (isExpense)
          ? await db.insert('expense_categories', data.toMap())
          : await db.insert('income_categories', data.toMap());
    } else {
      return 0;
    }
  }

  Future<int> deleteTransactions(bool expenses, {int id}) async {
    var db = await getDB();
    if (expenses) {
      return (id == null)
          ? await db.delete('expenses')
          : await db.delete('expenses', where: "id = ?", whereArgs: [id]);
    } else {
      return (id == null)
          ? await db.delete('incomes')
          : await db.delete('incomes', where: "id = ?", whereArgs: [id]);
    }
  }

  Future<int> deleteCategories(bool expenses, {int id}) async {
    var db = await getDB();
    int queryState;
    if (expenses) {
      if (id == null) {
        await updateTransactionByCategory(true,
            categoryId: id, newCategoryId: 6);
        queryState =
            await db.delete('expense_categories', where: "is_default != 1");
      } else {
        await updateTransactionByCategory(true,
            categoryId: id, newCategoryId: 6);
        queryState = await db.delete('expense_categories',
            where: "id = ? AND is_default != 1", whereArgs: [id]);
      }
    } else {
      if (id == null) {
        await updateTransactionByCategory(false,
            categoryId: id, newCategoryId: 4);
        queryState =
            await db.delete('income_categories', where: "is_default != 1");
      } else {
        await updateTransactionByCategory(false,
            categoryId: id, newCategoryId: 4);
        queryState = await db.delete('income_categories',
            where: "id = ? AND is_default != 1", whereArgs: [id]);
      }
    }
    return queryState;
  }

  Future<int> deleteUsers({int id}) async {
    var db = await getDB();
    if (id == null)
      return db.delete('users');
    else
      return db.delete('users', where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateTransaction(
      bool isExpense, IncomeExpense transaction, IncomeExpense newData) async {
    var db = await getDB();
    if (isExpense) {
      return await db.update('expenses', newData.toMap(),
          where: "id = ?", whereArgs: [transaction.id]);
    } else {
      return await db.update('incomes', newData.toMap(),
          where: "id = ?", whereArgs: [transaction.id]);
    }
  }

  Future<int> updateTransactionByCategory(bool isExpense,
      {int transacId, int categoryId, int newCategoryId}) async {
    var db = await getDB();
    String tbl = (isExpense) ? 'expenses' : 'incomes';
    print("DELETING FROM $tbl");
    String whereID = (transacId != null) ? ' WHERE id = $transacId' : '';
    String whereCatID = "";
    if (categoryId != null) {
      whereCatID = (transacId != null)
          ? ' AND category_id = $categoryId'
          : ' WHERE category_id = $categoryId';
    }
    String querySuffix = "$whereID$whereCatID";
    print('''UPDATE $tbl SET category_id = $newCategoryId$querySuffix''');
    return db.rawInsert(
        '''UPDATE $tbl SET category_id = $newCategoryId$querySuffix''');
  }

  Future<int> updateUser(User data, User newData) async {
    var db = await getDB();
    return db.update('users', newData.toMap(),
        where: "id = ?", whereArgs: [data.id]);
  }

  Future<int> updateCategory(
      bool isExpense, Category category, Category newData) async {
    var db = await getDB();
    if (isExpense) {
      return await db.update('expense_categories', newData.toMap(),
          where: "id = ?", whereArgs: [category.id]);
    } else {
      return await db.update('income_categories', newData.toMap(),
          where: "id = ?", whereArgs: [category.id]);
    }
  }

  Future<bool> userAlreadyExists(String user) async {
    var db = await getDB();
    List<Map<String, dynamic>> userData;
    userData = await db.query('users', where: "user = ?", whereArgs: [user]);
    return userData.isNotEmpty;
  }
}
