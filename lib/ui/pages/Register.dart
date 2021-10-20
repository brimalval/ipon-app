import 'package:flutter/material.dart';
import 'package:project/models/user.dart';
import 'package:project/palette.dart';
import 'package:project/ui/ScaffoldWithBG.dart';
import 'package:project/ui/ipon_tfield.dart';
import 'package:project/ui/large_button.dart';
import 'package:project/ui/HomeBlock.dart';

class Register extends StatefulWidget {
  final Function _listener;
  final Function _dblistener;
  Register(this._listener, this._dblistener);
  @override
  _RegisterState createState() => _RegisterState(_listener, _dblistener);
}

class _RegisterState extends State<Register> {
  final Function _listener;
  final Function _dblistener;
  _RegisterState(this._listener, this._dblistener);

  var _fnCtr = TextEditingController();
  var _lnCtr = TextEditingController();
  var _emailCtr = TextEditingController();
  var _userCtr = TextEditingController();
  var _passCtr = TextEditingController();

  bool _hasEmptyFields() {
    return (_fnCtr.text.trim() == "" ||
        _lnCtr.text.trim() == "" ||
        _emailCtr.text.trim() == "" ||
        _userCtr.text.trim() == "" ||
        _passCtr.text.trim() == "");
  }

  @override
  void dispose() {
    _fnCtr.dispose();
    _lnCtr.dispose();
    _emailCtr.dispose();
    _userCtr.dispose();
    _passCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ScaffoldWithBG(
      showDrawer: false,
      body: Builder(
          builder: (context) => ListView(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        color: IponColors.white,
                        width: double.infinity,
                        height: (height * 0.7375),
                      ),
                      HomeBlock(
                        "Register",
                        rows: [
                          IponTField(
                            controller: this._fnCtr,
                            keyboardType: TextInputType.name,
                            label: "First Name",
                          ),
                          IponTField(
                            controller: this._lnCtr,
                            keyboardType: TextInputType.name,
                            label: "Last Name",
                          ),
                          IponTField(
                            controller: this._emailCtr,
                            keyboardType: TextInputType.emailAddress,
                            label: "E-Mail",
                          ),
                          IponTField(
                            controller: this._userCtr,
                            label: "Username",
                          ),
                          IponTField(
                            controller: this._passCtr,
                            label: "Password",
                            obscured: true,
                            margin: EdgeInsets.only(
                              top: 5,
                              bottom: 20,
                            ),
                          ),
                          SizedButton(
                            action: () {
                              if (_hasEmptyFields()) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text("Make sure to fill in all fields!"),
                                ));
                              } else {
                                User user = User(
                                  _fnCtr.text,
                                  _lnCtr.text,
                                  _emailCtr.text,
                                  _userCtr.text,
                                  _passCtr.text,
                                );
                                _dblistener(context, user);
                                _listener(_userCtr.text, _passCtr.text);
                              }
                            },
                            width: 250,
                            height: 50,
                            color: Colors.redAccent,
                            alignment: Alignment.center,
                            child: Text(
                              "Sign-up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
    );
  }
}
