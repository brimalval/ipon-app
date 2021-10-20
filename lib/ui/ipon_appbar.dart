import 'package:flutter/material.dart';
import 'package:project/palette.dart';
import 'package:project/ui/large_button.dart';

class IponAppBar extends StatelessWidget implements PreferredSizeWidget {
  var appBar;
  final List<Widget> actions;
  IponAppBar({Key key, this.actions}) : super(key: key) {
    appBar = AppBar(
      actions: actions,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      title: Text(
        "iPon",
        style: TextStyle(
          fontSize: 30,
          letterSpacing: 4,
          fontFamily: "Century Gothics",
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return appBar;
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
