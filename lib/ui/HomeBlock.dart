import 'package:flutter/material.dart';
import 'package:project/palette.dart';
import 'package:project/ui/circle_btn.dart';

import 'BlockTitleText.dart';

class HomeBlock extends StatelessWidget {
  final String _title;
  final List<Widget> rows;
  final Function addAction;
  final double titleSize;
  final Color titleColor;
  final TextStyle titleStyle;
  final EdgeInsets margin;
  HomeBlock(this._title, {this.rows = const [], this.addAction, this.titleSize, this.titleColor, this.titleStyle, this.margin});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: IponColors.white,
      ),
      margin: (margin == null) ? EdgeInsets.only(bottom: 20) : margin,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 45,
              right: 45,
              bottom: 20,
            ),
            child: Column(
              children: [
                BlockTitleText(
                  _title,
                  titleSize: titleSize,
                  titleColor: (titleColor == null) ? Colors.black : titleColor,
                  titleStyle: titleStyle,
                ),
                ...rows,
              ],
            ),
          ),
          (addAction != null)
              ? Container(
                  alignment: Alignment.topRight,
                  child: CircleButton(
                    child: Icon(
                      Icons.add,
                      color: IponColors.white,
                    ),
                    action: addAction,
                    padding: EdgeInsets.all(10),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
