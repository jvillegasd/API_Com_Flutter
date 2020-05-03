import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {

  final String userEmail;
  final String userPassword;
  final String userFullname;
  final String username;

  const UserInfo({ this.userEmail, this.userPassword, this.userFullname, this.username });

  @override
  Widget build(BuildContext context) {
    String info = "Username: ${username}\n" +
                  "Email: ${userEmail}\n" +
                  "Password: ${userPassword}\n";
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(userFullname),
            subtitle: Text(info),

            isThreeLine: true,
          )
        ],
      )
    );
  }
}