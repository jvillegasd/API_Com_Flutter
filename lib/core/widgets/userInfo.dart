import 'package:flutter/material.dart';
import '../models/courseMember.dart';
import '../widgets/customAlertDialog.dart';

class UserInfo extends StatelessWidget {
  String type;
  CourseMember courseMember;

  UserInfo({ this.courseMember, this.type});

  @override
  Widget build(BuildContext context) {
    String info = "Username: ${courseMember.username}\n" +
                  "Email: ${courseMember.email}\n";
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(courseMember.name),
            subtitle: Text(info),
            isThreeLine: true,
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) { return CustomAlertDialog(type: type, courseMember: courseMember); }
              );
            },
          )
        ],
      )
    );
  }
}