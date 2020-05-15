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
  var controllerEmail = new TextEditingController();
  var controllerPass = new TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      if (!userProvider.isLogged) {
        if (!_isLoading) {
          //Login card responsive operations
          double phoneWidth = MediaQuery.of(context).size.width;
          double phoneHeight = MediaQuery.of(context).size.height;

          if (userProvider.rememberUser && userProvider.currentUser != null && userProvider.currentUser.email != null && userProvider.currentUser.password != null) {
            controllerEmail = TextEditingController(text: userProvider.currentUser.email);
            controllerPass = TextEditingController(text: userProvider.currentUser.password);
          }
          print(userProvider.currentUser);
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
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                                child: LoginForm(
                                  userProvider: userProvider,
                                  formKey: _formKey,
                                  controllerEmail: controllerEmail,
                                  controllerPass: controllerPass,
                                  rememberUser: userProvider.rememberUser,
                                ))
                          ],
                        ),
                      ))));
        } else {
          return Scaffold(
              appBar: AppBar(title: Text("Login")),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _authentication(userProvider),
                  Text("Loading")
                ],
              )));
        }
      } else
        return Home();
    });
  }

  Widget _authentication(UserProvider userProvider) {
    userProvider.authentication().then((response) {
      setState(() {
        _isLoading = false;
      });
      return null;
    });
    return Center(child: CircularProgressIndicator());
  }
}
