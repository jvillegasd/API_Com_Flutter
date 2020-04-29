import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).authentication();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      if (userProvider.isLogged) {
        return Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: Container(
              child: Column(
                children: <Widget>[
                  Text('Email: ${userProvider.currentUser.email}'),
                  FlatButton(
                      onPressed: () async {
                        await userProvider.logOut();
                      },
                      child: Text('Logout'))
                ],
              ),
            ));
      } else return Login();
    });
  }
}
