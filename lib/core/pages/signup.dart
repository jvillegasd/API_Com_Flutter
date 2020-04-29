import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
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
            appBar: AppBar(title: Text("Sign in")),
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
                  FlatButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          String email = controllerEmail.text.toString();
                          String password = controllerPass.text.toString();
                          controllerPass.clear();
                          controllerEmail.clear();
                          await userProvider.signUp(email, password);

                          if (userProvider.isLogged) {
                            Navigator.pop(context);
                          } else
                            print("User registered");
                        }
                      },
                      child: Text('Submit'))
                ])));
      } else
        return Login();
    });
  }
}
