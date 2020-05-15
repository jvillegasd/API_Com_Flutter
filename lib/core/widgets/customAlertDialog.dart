import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../pages/login.dart';
import '../models/courseMember.dart';

class CustomAlertDialog extends StatefulWidget {
  String type;
  CourseMember courseMember;

  CustomAlertDialog({this.type, this.courseMember});

  StateAlertDialog createState() => StateAlertDialog();
}

class StateAlertDialog extends State<CustomAlertDialog> {
  bool _isLoading = true;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context, listen: false).authentication();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      if (userProvider.isLogged) {
        return AlertDialog(
          backgroundColor: Colors.yellow[200],
          title: Text("${widget.type} details",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20.0)),
          content: Column(children: <Widget>[
            Expanded(child: Text("Name: ${widget.courseMember.name}")),
            Expanded(child: Text("Username: ${widget.courseMember.username}")),
            Expanded(child: Text("Phone: ${widget.courseMember.phone}")),
            Expanded(child: Text("Email: ${widget.courseMember.email}")),
            Expanded(child: Text("City: ${widget.courseMember.city}")),
            Expanded(child: Text("Country: ${widget.courseMember.country}")),
            Expanded(child: Text("Bithday: ${widget.courseMember.birthdate}")),
          ]),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      } else {
        return Login();
      }
    });
  }
}
