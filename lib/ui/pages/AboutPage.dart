import 'package:flutter/material.dart';
import 'package:project/ui/BlockTitleText.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/mainmenu/ReportRow.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBG(
      showAppBar: true,
      showDrawer: false,
      body: Container(
        child: HomeBlock(
          "About",
          rows: [
            BlockTitleText(
              "Team behind the project",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
            ),
            BlockTitleText(
              "CARLOS, Ted Bryan",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            BlockTitleText(
              "MARQUEZ, Zaira",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            BlockTitleText(
              "MENDOZA, Mickaela Jeorge",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            BlockTitleText(
              "VALENCIA, Brian Malcolm",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 100),
            ),
            BlockTitleText(
              "End-User License Agreement",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
            ),
            BlockTitleText(
              "In using this app, you agree to give each of the four (4) team members a grade equivalent to the GPA of 1.25 or 1.",
              titleStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
