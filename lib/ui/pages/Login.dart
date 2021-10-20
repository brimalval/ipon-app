import 'package:flutter/material.dart';
import 'package:project/models/user.dart';
import 'package:project/palette.dart';
import 'package:project/ui/BlockTitleText.dart';
import 'package:project/ui/pages/Register.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/ipon_tfield.dart';
import 'package:project/ui/large_button.dart';
import 'package:project/ui/HomeBlock.dart';
import 'package:project/util/DBHelper.dart';

class Login extends StatefulWidget {
  final Function loginListener;
  Login({this.loginListener});

  @override
  _LoginState createState() {
    return _LoginState(loginListener: loginListener);
  }
}

class _LoginState extends State<Login> {
  DBHelper _dbHelper = DBHelper();
  final Function loginListener;
  _LoginState({this.loginListener});
  var _userController = TextEditingController();
  var _passController = TextEditingController();
  List<User> _userlist;

  void _navSignup() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (builder) => Register(_setInfo, _addUser)));
  }

  void _setInfo(String user, String pass) {
    print("User: $user Pass: $pass");
    setState(() {
      _userController.text = user;
      _passController.text = pass;
    });
  }

  void _showSnack(BuildContext context, String message, {Icon leadingIcon}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            leadingIcon,
            Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              child: Text(message),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchUsers() async {
    _userlist = await _dbHelper.getUsers();
    setState(() {});
  }

  void _addUser(BuildContext context, User user) async {
    if (await _dbHelper.userAlreadyExists(user.user)) {
      print("TRIED PASSING USERNAME \"${user.user}\"");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("User already exists!")));
    } else {
      await _dbHelper.add(user);
      _fetchUsers();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  void _attemptLogin(
    BuildContext context,
    String user,
    String pass,
  ) {
    if (user.trim() == "" || pass.trim() == "") {
      _showSnack(
        context,
        "Don't leave a field empty!",
        leadingIcon: Icon(Icons.error),
      );
      return;
    }
    User currUser;
    print("_USERLIST LENGTH: ${_userlist.length}");
    //if(loginListener != null) loginListener(User("Brian", "Valencia", "email", "user", "pass"));
    for (User u in _userlist) {
      if (u.user == user) {
        currUser = u;
        break;
      }
    }
    if (currUser == null) {
      _showSnack(
        context,
        "Invalid username or password!",
        leadingIcon: Icon(Icons.error),
      );
      return;
    }
    if (currUser.pass != pass) {
      _showSnack(
        context,
        "Invalid username or password!",
        leadingIcon: Icon(Icons.error),
      );
    } else {
      _showSnack(
        context,
        "Welcome, ${currUser.firstName} ${currUser.lastName}!",
        leadingIcon: Icon(Icons.check),
      );
      if (loginListener != null) loginListener(currUser);
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userlist == null) {
      _fetchUsers();
    }
    var height = MediaQuery.of(context).size.height;
    return ScaffoldWithBG(
      showAppBar: false,
      body: Builder(
        builder: (context) => Container(
          margin: EdgeInsets.only(
            top: height * 0.30,
          ),
          child: ListView(
            children: [
              BlockTitleText(
                "iPon",
                titleStyle: TextStyle(
                  fontSize: 30,
                  letterSpacing: 4,
                  fontFamily: "Century Gothics",
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    color: IponColors.white,
                    width: double.infinity,
                    height: (height * 0.545),
                  ),
                  HomeBlock(
                    "",
                    rows: [
                      IponTField(
                        controller: _userController,
                        label: "Username",
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                      ),
                      IponTField(
                        controller: _passController,
                        label: "Password",
                        obscured: true,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 20,
                        ),
                      ),
                      SizedButton(
                        action: () => _attemptLogin(
                          context,
                          _userController.text,
                          _passController.text,
                        ),
                        width: 250,
                        height: 50,
                        color: Colors.redAccent,
                        alignment: Alignment.center,
                        child: Text(
                          "Log-in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () => _navSignup(),
                          child: Text(
                            "Don't have an account?",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
