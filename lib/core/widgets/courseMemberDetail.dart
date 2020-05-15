import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../pages/login.dart';
import '../models/courseMember.dart';
import '../widgets/dialogMessage.dart';

class CourseMemberDetail extends StatefulWidget {
  String type;
  CourseMember courseMember;

  CourseMemberDetail({this.type, this.courseMember});

  StateDetail createState() => StateDetail();
}

class StateDetail extends State<CourseMemberDetail> {
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
        if (!_isLoading) {
          return AlertDialog(
            backgroundColor: Colors.yellow[200],
            title: Text("${widget.type} details",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20.0)),
            content: Column(children: <Widget>[
              Expanded(child: Text("Name: ${widget.courseMember.name}")),
              Expanded(
                  child: Text("Username: ${widget.courseMember.username}")),
              Expanded(child: Text("Phone: ${widget.courseMember.phone}")),
              Expanded(child: Text("Email: ${widget.courseMember.email}")),
              Expanded(child: Text("City: ${widget.courseMember.city}")),
              Expanded(child: Text("Country: ${widget.courseMember.country}")),
              Expanded(
                  child: Text("Bithday: ${widget.courseMember.birthdate}")),
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
          return AlertDialog(
              backgroundColor: Colors.yellow[200],
              title: Text("${widget.type} details",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20.0)),
              content: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    _getDetails(userProvider),
                    Text("Loading details")
                  ])));
        }
      } else {
        return Login();
      }
    });
  }

  Widget _getDetails(UserProvider userProvider) {
    if (widget.type == "Student") {
      userProvider.getStudentDetails(widget.courseMember.id).then((response) {
        if (!response.containsKey("error")) {
          setState(() {
            widget.courseMember.name = response["name"];
            widget.courseMember.username = response["username"];
            widget.courseMember.phone = response["phone"];
            widget.courseMember.email = response["email"];
            widget.courseMember.city = response["city"];
            widget.courseMember.country = response["country"];
            widget.courseMember.birthdate = response["birthday"];
            _isLoading = false;
          });
          return null;
        } else {
          setState(() {
            _isLoading = false;
          });
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogMessage(
                    title: "Error", message: response["error"]);
              });
        }
      });
    } else {
      userProvider.getProfessorDetails(widget.courseMember.id).then((response) {
        if (!response.containsKey("error")) {
          setState(() {
            widget.courseMember.name = response["name"];
            widget.courseMember.username = response["username"];
            widget.courseMember.phone = response["phone"];
            widget.courseMember.email = response["email"];
            widget.courseMember.city = response["city"];
            widget.courseMember.country = response["country"];
            widget.courseMember.birthdate = response["birthday"];
            _isLoading = false;
          });
          return null;
        } else {
          setState(() {
            _isLoading = false;
          });
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogMessage(
                    title: "Error", message: response["error"]);
              });
        }
      });
    }
    return Center(child: CircularProgressIndicator());
  }
}
