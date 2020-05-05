import 'package:flutter/material.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';
import 'package:simple_api_consumer_login/core/widgets/dialogMessage.dart';

class SignInForm extends StatefulWidget {
  final UserProvider userProvider;
  final formKey;
  final controllerEmail;
  final controllerPass;
  final controllerUsername;
  final controllerName;
  bool _isLoading = false;
  User newUser;

  SignInForm(
      {Key key,
      this.userProvider,
      this.formKey,
      this.controllerEmail,
      this.controllerPass,
      this.controllerUsername,
      this.controllerName})
      : super(key: key);

  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomTextField(
                labelText: "Name",
                hintText: "Type your name here!",
                prefixIcon: Icon(Icons.face),
                obscureText: false,
                validator: (name) {
                  if (name.isEmpty) return "Please, enter a name!";
                  return null;
                },
                textFieldController: widget.controllerName,
              ),
              CustomTextField(
                labelText: "Username",
                hintText: "Type your username here!",
                prefixIcon: Icon(Icons.account_circle),
                obscureText: false,
                validator: (username) {
                  if (username.isEmpty) return "Please, enter an username!";
                  return null;
                },
                textFieldController: widget.controllerUsername,
              ),
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
              Container(
                  child: (widget._isLoading)
                      ? _signUp(widget.userProvider, widget.newUser)
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () async {
                            if (widget.formKey.currentState.validate()) {
                              String email =
                                  widget.controllerEmail.text.toString();
                              String password =
                                  widget.controllerPass.text.toString();
                              String username =
                                  widget.controllerUsername.text.toString();
                              String name =
                                  widget.controllerName.text.toString();

                              setState(() {
                                widget.newUser =
                                    User(email, password, username, name);
                                widget._isLoading = true;
                              });
                            }
                          },
                          child: Text('Submit')))
            ]));
  }

  Widget _signUp(UserProvider userProvider, User newUser) {
    userProvider.signUp(newUser).then((response) {
      if (!response.containsKey("error")) {
        setState(() {
          widget.controllerPass.clear();
          widget.controllerEmail.clear();
          widget.controllerUsername.clear();
          widget.controllerName.clear();
          Navigator.pop(context);
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
