import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/home.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';

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
                              child: _loginForm(userProvider))
                        ],
                      ),
                    ))));
      } else
        return Home();
    });
  }

  Widget _loginForm(UserProvider userProvider) {
    return Form(
        key: _formKey,
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
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      String email = controllerEmail.text.toString();
                      String password = controllerPass.text.toString();
                      controllerPass.clear();
                      controllerEmail.clear();
                      await userProvider.signIn(email, password);
                    }
                  },
                  child: Text('Sign in')),
              FlatButton(
                  onPressed: () {
                    _formKey.currentState.reset();
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Sign up'))
            ]));
  }
}
