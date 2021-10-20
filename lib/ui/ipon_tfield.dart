import 'package:flutter/material.dart';

class IponTField extends StatefulWidget {
  final String label;
  final bool obscured;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool editable;
  final Widget prefix;
  final String name;
  IponTField(
      {this.label,
      this.obscured,
      this.padding,
      this.margin,
      this.keyboardType,
      this.controller,
      this.editable = true,
      this.name,
      this.prefix});
  @override
  _IponTFieldState createState() => _IponTFieldState(
        label: label,
        obscured: obscured,
        padding: padding,
        margin: margin,
        keyboardType: keyboardType,
        controller: controller,
        editable: editable,
        prefix: prefix,
        name: name,
      );
}

class _IponTFieldState extends State<IponTField> {
  final Widget prefix;
  final String label;
  final bool obscured;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool editable;
  final String name;
  _IponTFieldState(
      {this.label,
      this.obscured,
      this.padding,
      this.margin,
      this.keyboardType,
      this.controller,
      this.editable = true,
      this.name,
      this.prefix});
  @override
  void dispose() {
    if (this.controller != null) this.controller.dispose();
    super.dispose();
  }

  bool initName = false;

  @override
  Widget build(BuildContext context) {
    if(!initName){
      controller.text = name;
      initName = true;
    }
    return Container(
      margin: (this.margin == null)
          ? EdgeInsets.only(
              top: 5,
              bottom: 5,
            )
          : this.margin,
      padding: this.padding,
      child: TextField(
        readOnly: !this.editable,
        keyboardType:
            (this.keyboardType == null) ? TextInputType.text : keyboardType,
        controller: this.controller,
        autofocus: false,
        obscureText: (obscured == null) ? false : this.obscured,
        decoration: InputDecoration(
          prefix: prefix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          labelText: this.label,
        ),
      ),
    );
  }

  String get text {
    return controller.text;
  }
  
}
