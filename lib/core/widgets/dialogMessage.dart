import 'package:flutter/material.dart';

class DialogMessage extends StatelessWidget {
  final String title;
  final String message;

  const DialogMessage({this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
