import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  final String _text;
  final _action;
  DrawerButton(this._text, this._action);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75,
      child: FlatButton(
        onPressed: _action,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            _text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
