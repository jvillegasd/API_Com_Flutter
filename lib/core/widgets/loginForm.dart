import 'package:flutter/material.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';

class LoginForm extends StatelessWidget {
  final formKey;
  final controllerEmail;
  final controllerPass;
  final UserProvider userProvider;

  const LoginForm(
      {this.userProvider,
      this.formKey,
      this.controllerEmail,
      this.controllerPass});

  Widget build(BuildContext context) {
    return Form(
        key: formKey,
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
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      String email = controllerEmail.text.toString();
                      String password = controllerPass.text.toString();
                      User newUser = User(email, password, "", "");
                      controllerPass.clear();
                      controllerEmail.clear();

                      userProvider.signIn(newUser);
                    }
                  },
                  child: Text('Sign in')),
              FlatButton(
                  onPressed: () {
                    formKey.currentState.reset();
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Sign up'))
            ]));
  }
}
