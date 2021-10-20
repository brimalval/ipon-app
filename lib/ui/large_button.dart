import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SizedButton extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final Widget child;
  final double width;
  final double height;
  final Function action;
  final Alignment alignment;
  final double borderRadius;
  SizedButton(
      {this.padding,
      this.borderRadius,
      this.margin,
      this.color,
      this.child,
      this.width,
      this.height,
      this.action,
      this.alignment});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      margin: this.margin,
      alignment: this.alignment,
      child: Material(
        color: (this.color == null) ? Colors.blue : this.color,
        borderRadius: BorderRadius.all(Radius.circular(this.height)),
        child: InkWell(
          onTap: this.action,
          splashColor: Colors.white24,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(this.height)),
            ),
            width: this.width,
            height: this.height,
            child: Container(
              alignment: Alignment.center,
              child: this.child,
            ),
          ),
        ),
      ),
    );
  }
}
