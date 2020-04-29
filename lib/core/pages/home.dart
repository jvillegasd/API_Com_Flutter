import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';
import 'package:simple_api_consumer_login/core/widgets/userInfo.dart';

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
        String currentUserEmail = userProvider.currentUser.email;
        return Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserInfo(userEmail: currentUserEmail),
                logOutButton(userProvider)
              ]
            ));
      } else return Login();
    });
  }

  Widget logOutButton(UserProvider userProvider) {
    return RaisedButton(
      child: Text("Logout"),
      onPressed: () async {
        await userProvider.logOut();
      },
    );
  }
}