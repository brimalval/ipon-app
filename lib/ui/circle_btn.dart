import 'package:flutter/material.dart';
import 'package:project/palette.dart';

class CircleButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function action;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final EdgeInsets innerMargin;
  CircleButton(
      {this.color = IponColors.blue,
      this.child,
      this.action,
      this.padding = const EdgeInsets.all(5),
      this.margin,
      this.innerMargin});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipOval(
        child: Container(
          margin: innerMargin,
          child: Material(
            color: color,
            child: InkWell(
              child: SizedBox(
                child: child,
                height: 20+(padding.bottom * 2),
                width: 20+(padding.left * 2),
              ),
              splashColor: Colors.white70,
              onTap: action,
            ),
          ),
        ),
      ),
    );
  }
}
