import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/home.dart';

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
      if (!userProvider.isLogged) {
        return Scaffold(
            appBar: AppBar(title: Text("Login")),
            body: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Expanded(
                    child: TextFormField(
                        controller: controllerEmail,
                        validator: (value) {
                          if (value.isEmpty) return "Please, enter an email!";
                          return null;
                        }),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controllerPass,
                      validator: (value) {
                        if (value.isEmpty) return "Please, enter a password!";
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          String email = controllerEmail.text.toString();
                          String password = controllerPass.text.toString();
                          controllerPass.clear();
                          controllerEmail.clear();
                          await userProvider.signIn(email, password);
                        }
                      },
                      child: Text('Sign up')),
                  FlatButton(
                      onPressed: () {
                        _formKey.currentState.reset();
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: Text('Sign in'))
                ])));
      } else
        return Home();
    });
  }
}
