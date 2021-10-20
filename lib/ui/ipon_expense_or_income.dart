import 'package:flutter/material.dart';

class IponCheckBoxes extends StatefulWidget {
  final Function _getListener;
  IponCheckBoxes(this._getListener);
  @override
  _IponCheckBoxesState createState() => _IponCheckBoxesState(_getListener);
}

class _IponCheckBoxesState extends State<IponCheckBoxes> {
  final Function _getListener;
  _IponCheckBoxesState(this._getListener);

  int group = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                Text(
                  "Expense",
                  style: TextStyle(
                    color:
                        (group == 1) ? ThemeData().accentColor : Colors.black,
                    fontSize: 20,
                  ),
                ),
                Radio(
                  activeColor: ThemeData().accentColor,
                  groupValue: group,
                  value: 1,
                  onChanged: (value) {
                    setState(() => group = value);
                    _getListener(value);
                  },
                ),
              ],
            )),
        Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Row(
              children: [
                Text(
                  "Income",
                  style: TextStyle(
                    color:
                        (group == 2) ? ThemeData().accentColor : Colors.black,
                    fontSize: 20,
                  ),
                ),
                Radio(
                  activeColor: ThemeData().accentColor,
                  groupValue: group,
                  value: 2,
                  onChanged: (value) {
                    setState(() => group = value);
                    _getListener(value);
                  },
                ),
              ],
            ))
      ],
    );
  }
}
