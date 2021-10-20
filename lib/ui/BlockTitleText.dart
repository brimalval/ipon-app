import 'package:flutter/material.dart';

class BlockTitleText extends StatelessWidget {
  final String _text;
  final double titleSize;
  final Color titleColor;
  final TextStyle titleStyle;
  BlockTitleText(
    this._text, {
    this.titleSize,
    this.titleColor,
    this.titleStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      alignment: Alignment.center,
      child: Text(
        _text,
        style: (titleStyle == null) ? TextStyle(
          color: (titleColor == null) ? Colors.black : titleColor,
          fontFamily: "Roboto",
          fontSize: (titleSize == null) ? 24 : titleSize,
          fontWeight: FontWeight.w900,
        ) : titleStyle,
      ),
    );
  }
}
