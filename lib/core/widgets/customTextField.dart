import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;
  final Function(String) validator;
  final TextEditingController textFieldController;

  CustomTextField(
      {this.labelText,
      this.hintText,
      this.prefixIcon,
      this.obscureText,
      this.validator,
      this.textFieldController});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: phoneWidth * 0.65,
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        child: _customTF()
      ),
    );
  }

  Widget _customTF() {
    return TextFormField(
      validator: validator,
      controller: textFieldController,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blue, width: 2)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
          borderSide: BorderSide(color: Colors.blue)
        ),
        labelText: labelText,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 3.0)
      )
    );
  }
}
