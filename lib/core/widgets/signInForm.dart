import 'package:flutter/material.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';

class SignInForm extends StatelessWidget {
  final UserProvider userProvider;
  final formKey;
  final controllerEmail;
  final controllerPass;
  final controllerUsername;
  final controllerName;

  const SignInForm(
      {this.userProvider,
      this.formKey,
      this.controllerEmail,
      this.controllerPass,
      this.controllerUsername,
      this.controllerName});

  Widget build(BuildContext context) {
    return Form(
        key: formKey,
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
                textFieldController: controllerName,
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
                textFieldController: controllerUsername,
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
                  textFieldController: controllerEmail),
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
                  textFieldController: controllerPass),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      String email = controllerEmail.text.toString();
                      String password = controllerPass.text.toString();
                      String username = controllerUsername.text.toString();
                      String name = controllerName.text.toString();
                      User newUser = User(email, password, username, name);

                      controllerPass.clear();
                      controllerEmail.clear();
                      controllerUsername.clear();
                      controllerName.clear();

                      _signUp(context, newUser, userProvider);
                    }
                  },
                  child: Text('Submit'))
            ]));
  }

  Future<void> _signUp(
      BuildContext context, User newUser, UserProvider userProvider) async {
    String response = await userProvider.signUp(newUser);

    print(response);
    if (userProvider.isLogged) {
      Navigator.pop(context);
    } else
      print("User registered");
  }
}
