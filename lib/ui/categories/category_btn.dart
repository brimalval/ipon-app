import 'package:flutter/material.dart';
import 'package:project/ui/circle_btn.dart';

class LblButton extends StatelessWidget {
  final Widget child;
  final String lbl;
  final Function onPressed;
  LblButton(this.child, this.lbl, {this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12, 
            bottom: 12,
          ),
          child: CircleButton(
            action: onPressed,
            child: child,
            color: Colors.blue,
            padding: EdgeInsets.all(15),
          ),
        ),
        Center(
          child: Text("${lbl.substring(0,1).toUpperCase()}${lbl.substring(1)}"),
        ),
      ],
    );
  }
}
