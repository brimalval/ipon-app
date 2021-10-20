import 'package:flutter/material.dart';
import 'package:project/ui/BlockTitleText.dart';
import 'package:project/ui/mainmenu/DrawerButton.dart';
import 'package:project/ui/pages/AboutPage.dart';

class MainDrawer extends StatelessWidget {
  final Function homeAction;
  final Function graphAction;
  final Function categoryAction;
  final Function aboutAction;
  final Function logOutAction;
  final String firstName;
  final String lastName;
  MainDrawer({
    this.homeAction,
    this.aboutAction,
    this.categoryAction,
    this.graphAction,
    this.logOutAction,
    this.firstName,
    this.lastName,
  });
  String nameStr = "";
  @override
  Widget build(BuildContext context) {
    nameStr = "";
    if(firstName != null){
      nameStr += "$firstName ";
    }if(lastName != null){
      nameStr += "$lastName";
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(
          top: 50,
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            width: double.infinity,
            margin: EdgeInsets.only(
              top: 75,
              left: 75,
              right: 75,
              bottom: (firstName != null || lastName != null) ? 20 : 75,
            ),
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage('graphics/user.png'),
            ),
          ),
          (firstName != null || lastName != null) ? BlockTitleText("$nameStr") : Container(),
          DrawerButton("Home", homeAction),
          DrawerButton("Graph", graphAction),
          DrawerButton("Category", categoryAction),
          DrawerButton("About", () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => About()))),
          DrawerButton("Log-out", logOutAction),
        ],
      ),
    );
  }
}
