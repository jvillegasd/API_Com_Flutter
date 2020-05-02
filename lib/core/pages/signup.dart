import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';
import 'package:simple_api_consumer_login/core/widgets/customTextField.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = new TextEditingController();
  final controllerPass = new TextEditingController();
  final controllerUsername = new TextEditingController();
  final controllerName = new TextEditingController();

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
                    height: phoneHeight * 0.45,
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
                      String username = controllerUsername.toString();
                      String name = controllerName.toString();
                      User newUser = User(email, password, username, name);

                      controllerPass.clear();
                      controllerEmail.clear();
                      controllerUsername.clear();
                      controllerName.clear();
                      
                      await userProvider.signUp(newUser);

                      if (userProvider.isLogged) {
                        Navigator.pop(context);
                      } else
                        print("User registered");
                    }
                  },
                  child: Text('Submit')),
            ]));
  }
}
