import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = new TextEditingController();
  final _controllerPass = new TextEditingController();
  final _controllerUsername = new TextEditingController();
  final _controllerName = new TextEditingController();

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
            appBar: AppBar(title: Text("Sign Up")),
            body: Center(
                child: Container(
                    width: phoneWidth * 0.80,
                    height: phoneHeight * 0.50,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                              child: _signUpForm(userProvider))
                        ],
                      ),
                    ))));
      } else
        return Login();
    });
  }

  Widget _signUpForm(UserProvider userProvider) {
    return Form(
        key: _formKey,
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
                textFieldController: _controllerName,
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
                textFieldController: _controllerUsername,
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
                  textFieldController: _controllerEmail),
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
                  textFieldController: _controllerPass),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      String email = _controllerEmail.text.toString();
                      String password = _controllerPass.text.toString();
                      String username = _controllerUsername.text.toString();
                      String name = _controllerName.text.toString();
                      User newUser = User(email, password, username, name);

                      _controllerPass.clear();
                      _controllerEmail.clear();
                      _controllerUsername.clear();
                      _controllerName.clear();

                      _signUp(context, newUser, userProvider);
                    }
                  },
                  child: Text('Submit'))
            ]));
  }

  Future<void> _signUp(BuildContext context, User newUser, UserProvider userProvider) async {
    String response = await userProvider.signUp(newUser);

    print(response);
    if (userProvider.isLogged) {
      Navigator.pop(context);
    } else
      print("User registered");
  }
}
