import 'package:flutter/material.dart';
import 'package:project/palette.dart';

class CategoryDropdownItem extends StatelessWidget {
  final int value;
  final Icon icon;
  final String text;
  CategoryDropdownItem({this.value, this.icon, this.text});
  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: IponColors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: icon,
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
          ),
          Text(text),
        ],
      ),
    );
  }
}
