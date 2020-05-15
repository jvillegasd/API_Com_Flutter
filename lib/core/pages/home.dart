import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import 'package:simple_api_consumer_login/core/pages/login.dart';
import 'package:simple_api_consumer_login/core/models/course.dart';
import 'package:simple_api_consumer_login/core/widgets/courseCard.dart';
import 'package:simple_api_consumer_login/core/widgets/dialogMessage.dart';
import '../utils/hexColor.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //Widget variables to use
  List<Course> currentUserCourses = new List<Course>();
  bool _isLoading = true;
  bool _isLoadingAddCourse = false;
  bool _isLoadingRestartDB = false;

  //Toggle animation variables
  bool _toggleIsOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  double _fabElevation = 0.0;

  @override
  initState() {
    //Toogle animatation operations
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {
              if (_toggleIsOpened) {
                _fabElevation = 15.0;
              } else {
                _fabElevation = 0.0;
              }
            });
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.00, 1.00, curve: _curve)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));

    //Normal init state operations
    super.initState();
    Provider.of<UserProvider>(context, listen: false).authentication();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!_toggleIsOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _toggleIsOpened = !_toggleIsOpened;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      if (userProvider.isLogged) {
        if (!_isLoading) {
          //FAB responsive operations
          double phoneWidth = MediaQuery.of(context).size.width;
          double responseWidth = phoneWidth * 0.911;
          bool isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          if (isLandscape) responseWidth = phoneWidth * 0.952;

          return Scaffold(
              appBar: AppBar(title: Text("Courses")),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[Flexible(child: _list())]),
              floatingActionButton: Container(
                  width: responseWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Transform(
                          transform: Matrix4.translationValues(
                              _translateButton.value * 3.0, 0.0, 0.0),
                          child: _logoutButton(userProvider)),
                      Transform(
                          transform: Matrix4.translationValues(
                              _translateButton.value * 2.0, 0.0, 0.0),
                          child: _addButton(userProvider)),
                      Transform(
                          transform: Matrix4.translationValues(
                              _translateButton.value, 0.0, 0.0),
                          child: _resetButton(userProvider)),
                      _toggleButton()
                    ],
                  )));
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Courses")),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  _getCourses(userProvider),
                  Text("Loading courses")
                ])),
          );
        }
      } else
        return Login();
    });
  }

  Widget _list() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: currentUserCourses.length,
      itemBuilder: (context, index) {
        Course course = currentUserCourses[index];
        return CourseCard(course: course);
      },
    );
  }

  Widget _toggleButton() {
    return FloatingActionButton(
        backgroundColor: _animateColor.value,
        onPressed: animate,
        tooltip: "Toggle",
        child: AnimatedIcon(
            icon: AnimatedIcons.menu_close, progress: _animateIcon));
  }

  Widget _addButton(UserProvider userProvider) {
    return (_isLoadingAddCourse)
        ? _addCourse(userProvider)
        : FloatingActionButton(
          heroTag: null,
            onPressed: () {
              setState(() {
                _isLoadingAddCourse = true;
              });
            },
            tooltip: "Create a new course",
            child: Icon(Icons.add),
            elevation: _fabElevation,
          );
  }

  Widget _logoutButton(UserProvider userProvider) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async {
        await userProvider.logOut();
      },
      tooltip: "Logout",
      child: Icon(Icons.exit_to_app),
      backgroundColor: Colors.red,
      elevation: _fabElevation,
    );
  }

  Widget _resetButton(UserProvider userProvider) {
    return (_isLoadingRestartDB)
        ? _restartCourses(userProvider)
        : FloatingActionButton(
          heroTag: null,
            onPressed: () {
              setState(() {
                _isLoadingRestartDB = true;
              });
            },
            tooltip: "Reset DB",
            child: Icon(Icons.loop),
            backgroundColor: HexColors.toColor("#FDE74C"),
            foregroundColor: Colors.blueGrey,
            elevation: _fabElevation,
          );
  }

  Widget _addCourse(UserProvider userProvider) {
    userProvider.createCourse().then((response) {
      if (!response.containsKey("error")) {
        Course newCourse = Course(response["id"], response["name"],
            response["professor"], response["students"]);
        setState(() {
          _isLoadingAddCourse = false;
          currentUserCourses.add(newCourse);
        });
        return null;
      } else {
        setState(() {
          _isLoadingAddCourse = false;
        });
        print(response["message"]);
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogMessage(title: "Error", message: response["error"]);
            });
      }
    });
    return Container(
      child: CircularProgressIndicator(),
      height: _fabHeight,
      width: _fabHeight,
    );
  }

  Widget _getCourses(UserProvider userProvider) {
    userProvider.getCourses().then((response) {
      if (!response.containsKey("error")) {
        List<dynamic> courses = response["courses"];
        for (var element in courses) {
          Course course = Course(element["id"], element["name"],
              element["professor"], element["students"]);
          currentUserCourses.add(course);
        }
        setState(() {
          _isLoading = false;
        });
        return null;
      } else {
        setState(() {
          _isLoading = false;
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

  Widget _restartCourses(UserProvider userProvider) {
    userProvider.restartCourses().then((response) {
      if (!response.containsKey("error")) {
        currentUserCourses.clear();
        setState(() {
          _isLoadingRestartDB = false;
        });
        return null;
      } else {
        setState(() {
          _isLoadingRestartDB = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogMessage(title: "Error", message: response["error"]);
            });
      }
    });
    return Container(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(HexColors.toColor("#FDE74C")) ,
      ),
      height: _fabHeight,
      width: _fabHeight,
    );
  }
}
