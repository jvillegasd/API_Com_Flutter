import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/home.dart';
import 'package:simple_api_consumer_login/core/widgets/loginForm.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = new TextEditingController();
  final controllerPass = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).authentication();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      double phoneWidth = MediaQuery.of(context).size.width;
      double phoneHeight = MediaQuery.of(context).size.height;
      if (!userProvider.isLogged) {
        return Scaffold(
            appBar: AppBar(title: Text("Login")),
            body: Center(
                child: Container(
                    width: phoneWidth * 0.80,
                    height: phoneHeight * 0.45,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                              child: LoginForm(
                                  userProvider: userProvider,
                                  formKey: _formKey,
                                  controllerEmail: controllerEmail,
                                  controllerPass: controllerPass))
                        ],
                      ),
                    ))));
      } else
        return Home();
    });
  }
}
