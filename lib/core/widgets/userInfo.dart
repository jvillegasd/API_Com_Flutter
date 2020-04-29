import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {

  final String userEmail;
  final String userPassword;

  const UserInfo({ this.userEmail, this.userPassword });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(userEmail),
            subtitle: Text('Password: ${userPassword}'),
            isThreeLine: true,
          )
        ],
      )
    );
  }
}