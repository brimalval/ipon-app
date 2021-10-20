import 'package:flutter/material.dart';
import 'package:project/iconlist.dart';
import 'package:project/models/category.dart';
import 'package:project/palette.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/ipon_expense_or_income.dart';
import 'package:project/ui/ipon_tfield.dart';
import 'package:project/ui/large_button.dart';

class CategoryForm extends StatefulWidget {
  final bool isDefault;
  final bool isEditing;
  final Function addListener;
  final Function deleteListener;
  final Function updateListener;
  final int currUser;
  final Category categoryToBeEdited;
  CategoryForm(
      {this.isDefault = false,
      this.isEditing = false,
      this.addListener,
      this.deleteListener,
      this.updateListener,
      this.categoryToBeEdited,
      this.currUser});

  @override
  _CategoryFormState createState() => _CategoryFormState(
      isDefault: isDefault,
      isEditing: isEditing,
      addListener: addListener,
      deleteListener: deleteListener,
      updateListener: updateListener,
      categoryToBeEdited: categoryToBeEdited,
      currUser: currUser);
}

class _CategoryFormState extends State<CategoryForm> {
  bool isDefault;
  bool isEditing;
  final int currUser;
  final Function addListener;
  final Function updateListener;
  final Function deleteListener;
  final Category categoryToBeEdited;
  _CategoryFormState({
    this.addListener,
    this.deleteListener,
    this.updateListener,
    this.isDefault = false,
    this.isEditing = false,
    this.currUser,
    this.categoryToBeEdited,
  });
  bool _isExpense = true;
  final _nameController = TextEditingController();
  var _title;
  List<DropdownMenuItem> _iconList = [];
  int _currIcon;
  bool init = false;

  bool _hasEmptyFields() {
    return (_currIcon == null || _nameController.text.trim() == "");
  }

  void _switchType(int groupValue) {
    print("SWAPPING TYPES");
    switch (groupValue) {
      case 1:
        _currIcon = 1;
        _isExpense = true;
        _loadIcons(_isExpense);
        break;
      case 2:
        _currIcon = 1;
        _isExpense = false;
        _loadIcons(_isExpense);
        break;
    }
  }

  void _loadIcons(bool isExpense) {
    if (categoryToBeEdited != null) {
      isExpense = categoryToBeEdited.isAnExpense;
    }
    _iconList.clear();
    int i = 0;
    List<Icon> icons =
        (isExpense) ? ExpenseIconList.icons : IncomeIconList.icons;
    for (Icon icon in icons) {
      _iconList.add(
        DropdownMenuItem(
          value: i,
          child: Center(
              child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: IponColors.blue,
            ),
            child: icon,
          )),
        ),
      );
      i++;
    }
    setState(() {});
  }

  void _useAddListener(BuildContext context) {
    print("ADDING CATEGORY WITH $_isExpense ISEXPENSE VALUE");
    if (_hasEmptyFields()) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill up all the fields."),
        ),
      );
      return;
    }
    Category category = Category(
        _currIcon, currUser, _nameController.text, false,
        isExpense: _isExpense);
    addListener(category, _isExpense);
    Navigator.of(context).pop();
  }

  void _useUpdateListener(BuildContext context) {
    if (_hasEmptyFields()) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill up all the fields."),
        ),
      );
      return;
    }
    Category category = Category(
        _currIcon, currUser, _nameController.text, false,
        isExpense: _isExpense);
    updateListener(_isExpense, categoryToBeEdited, category);
    Navigator.of(context).pop();
  }

  void _useDeleteListener() {
    deleteListener(categoryToBeEdited.isAnExpense, categoryToBeEdited.id);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      _title = "Edit Category";
    } else if (!isEditing) {
      _title = "Add Category";
    }
    _title = (isDefault) ? "Default Category" : _title;

    if (_iconList.isEmpty && !isDefault) {
      _loadIcons(true);
    }

    if(!init && (categoryToBeEdited != null)){
      _currIcon = categoryToBeEdited.iconIndex;
      _isExpense = (categoryToBeEdited != null) ? categoryToBeEdited.isAnExpense : true;
      init = true;
      setState((){});
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
                    IponTField(
                      name: (categoryToBeEdited != null)
                          ? categoryToBeEdited.name
                          : null,
                      editable: !(isDefault),
                      margin: EdgeInsets.only(
                        top: 50,
                        bottom: 20,
                      ),
                      controller: _nameController,
                      label: "Name",
                    ),
                    ((!isDefault) && (!isEditing))
                        ? IponCheckBoxes(_switchType)
                        : Container(),
                    (!isDefault)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Icon: "),
                              SizedBox(
                                width: 75,
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: _currIcon,
                                  onChanged: (iconIndex) {
                                    setState(() {
                                      _currIcon = iconIndex;
                                    });
                                  },
                                  items: [
                                    ..._iconList,
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container(),
                    Container(
                      height: height * 0.25,
                      width: 1,
                    ),
                    (!isDefault)
                        ? SizedButton(
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
                            action: (!isEditing)
                                ? () => _useAddListener(context)
                                : () => _useUpdateListener(context),
                            alignment: Alignment.center,
                            color: IponColors.blue,
                            height: 50,
                            width: 150,
                          )
                        : Container(),
                    (!isDefault)
                        ? SizedButton(
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
                                ? () => _useDeleteListener()
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            alignment: Alignment.center,
                            color: Colors.redAccent,
                            height: 50,
                            width: 150,
                          )
                        : Container(),
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
