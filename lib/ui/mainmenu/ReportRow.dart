import 'package:flutter/material.dart';

class ReportRow extends StatelessWidget {
  final String _title;
  final String _amount;
  final Function action;
  ReportRow(this._title, this._amount, {this.action});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => action(),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          bottom: 25,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[850],
                ),
              ),
            ),
            Text(
              "₱ $_amount",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      )
    );
  }
}
