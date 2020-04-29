import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {

  final String userEmail;

  const UserInfo({ this.userEmail });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: accountIcon(),
            title: Text(userEmail),
            subtitle: Text("Current logged user"),
            isThreeLine: true,
          )
        ],
      )
    );
  }

  Icon accountIcon() {
    return Icon(Icons.account_circle);
  }
}