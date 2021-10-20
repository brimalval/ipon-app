import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/mainmenu/ReportRow.dart';

class GraphBreakdown extends StatelessWidget {
  final List<ReportRow> _rows;
  final Map<String, double> _dataMap;
  final String _title;
  GraphBreakdown(this._dataMap, this._rows, this._title);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(
          top: 30,
          bottom: 30,
        ),
        margin: EdgeInsets.only(
          top: 50,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white70,
        ),
        child: (_dataMap != null && _dataMap.isNotEmpty) ? PieChart(
          animationDuration: Duration(milliseconds: 16),
          dataMap: _dataMap,
          initialAngle: 0,
        ) : Container(),
      ),
      HomeBlock(
        _title,
        titleSize: 22,
        rows: (_rows.isNotEmpty) ? [..._rows] : [Text("No transactions made yet.")],
      ),
    ]);
  }
}
