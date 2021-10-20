import 'package:flutter/material.dart';
import 'package:project/ui/ipon_appbar.dart';
import 'package:project/ui/mainmenu/MainDrawer.dart';
import 'package:project/ui/pages/Categories.dart';
import 'package:project/ui/pages/Graphs.dart';
import 'package:project/ui/pages/Login.dart';

class ScaffoldWithBG extends StatelessWidget {
  final Widget body;
  final bool showDrawer;
  final bool showAppBar;
  final List<Widget> actions;
  final Function logOutAction;
  final Function graphAction;
  final Function categoryAction;
  final Function aboutAction;
  final String firstName;
  final String lastName;
  ScaffoldWithBG(
      {this.body,
      this.showDrawer = false,
      this.showAppBar = true,
      this.actions,
      this.logOutAction,
      this.firstName,
      this.lastName,
      this.graphAction,
      this.categoryAction,
      this.aboutAction,
      });

  void _navGraph(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => Graphs()));
  }

  void _navCategory(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => Categories()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('graphics/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: (showDrawer)
            ? MainDrawer(
                firstName: firstName,
                lastName: lastName,
                homeAction: () {
                  Navigator.of(context).pop();
                },
                graphAction: graphAction,
                categoryAction: categoryAction,
                logOutAction: () => logOutAction(),
              )
            : null,
        appBar: (showAppBar) ? IponAppBar(actions: actions) : null,
        body: this.body,
      ),
    );
  }
}
