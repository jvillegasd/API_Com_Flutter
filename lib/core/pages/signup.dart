import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';
import 'package:simple_api_consumer_login/core/widgets/signInForm.dart';

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
                              child: SignInForm(
                                userProvider: userProvider,
                                formKey: _formKey,
                                controllerEmail: _controllerEmail,
                                controllerPass: _controllerPass,
                                controllerUsername: _controllerUsername,
                                controllerName: _controllerName,
                              ))
                        ],
                      ),
                    ))));
      } else
        return Login();
    });
  }
}
