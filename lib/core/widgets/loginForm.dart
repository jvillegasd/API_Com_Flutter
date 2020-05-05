import 'package:flutter/material.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';
import 'package:simple_api_consumer_login/core/widgets/dialogMessage.dart';

class LoginForm extends StatefulWidget {
  final formKey;
  final controllerEmail;
  final controllerPass;
  final UserProvider userProvider;
  bool rememberUser;
  bool _isLoading = false;
  User newUser;

  LoginForm(
      {Key key,
      this.userProvider,
      this.formKey,
      this.controllerEmail,
      this.controllerPass,
      this.rememberUser})
      : super(key: key);

  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {

  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomTextField(
                  labelText: "Email",
                  hintText: "Type your email here!",
                  prefixIcon: Icon(Icons.email),
                  obscureText: false,
                  validator: (email) {
                    Pattern pattern =
                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
                    RegExp regex = RegExp(pattern);

                    if (email.isEmpty) return "Please, enter an email!";
                    if (!regex.hasMatch(email)) return "Invalid email address";
                    return null;
                  },
                  textFieldController: widget.controllerEmail),
              CustomTextField(
                  labelText: "Password",
                  hintText: "Type your password here!",
                  prefixIcon: Icon(Icons.lock),
                  obscureText: true,
                  validator: (password) {
                    Pattern pattern = r'^(\w|[^ ]){6,}$';
                    RegExp regex = RegExp(pattern);

                    if (password.isEmpty) return "Please, enter an password!";
                    if (!regex.hasMatch(password)) return "Invalid password";
                    return null;
                  },
                  textFieldController: widget.controllerPass),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: widget.rememberUser,
                    onChanged: (bool value) {
                      widget.userProvider.setRememberUser(value).then((response) {
                        setState(() {
                          widget.rememberUser = value;
                        });
                      });
                    },
                  ),
                  Text("Stay logged")
                ],
              ),
              Container(
                  child: (widget._isLoading)
                      ? _signIn(widget.userProvider, widget.newUser)
                      : (RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            if (widget.formKey.currentState.validate()) {
                              String email =
                                  widget.controllerEmail.text.toString();
                              String password =
                                  widget.controllerPass.text.toString();

                              setState(() {
                                widget.newUser = User(email, password, "", "");
                                widget._isLoading = true;
                              });
                            }
                          },
                          child: Text('Sign in')))),
              FlatButton(
                  onPressed: () {
                    widget.formKey.currentState.reset();
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Sign up'))
            ]));
  }

  Widget _signIn(UserProvider userProvider, User newUser) {
    userProvider.signIn(newUser).then((response) {
      if (!response.containsKey("error")) {
        setState(() {
          widget.newUser = null;
          widget._isLoading = false;
          widget.controllerPass.clear();
          widget.controllerEmail.clear();
        });
        return null;
      } else {
        setState(() {
          widget.newUser = null;
          widget._isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogMessage(title: "Error", message: response["error"]);
            });
      }
    });
    return Center(child: CircularProgressIndicator());
  }
}
