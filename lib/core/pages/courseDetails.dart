import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import '../pages/login.dart';
import '../widgets/dialogMessage.dart';
import '../widgets/userInfo.dart';
import '../models/courseMember.dart';

class CourseDetails extends StatefulWidget {
  int courseId;

  CourseDetails({this.courseId});

  CourseDetailsState createState() => CourseDetailsState();
}

class CourseDetailsState extends State<CourseDetails> {
  bool _isLoading = true;
  double _fabHeight = 56.0;
  bool _addLoading = false;
  CourseMember _courseProfessor;
  List<CourseMember> _studentList = new List<CourseMember>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context, listen: false).authentication();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      if (userProvider.isLogged) {
        if (!_isLoading) {
          return Scaffold(
              appBar: AppBar(title: Text("Course details")),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UserInfo(courseMember: _courseProfessor, type: "Professor"),
                  Container(
                    child: Expanded(
                        child: Column(
                      children: <Widget>[
                        Text("Student list"),
                        Flexible(child: _list())
                      ],
                    )),
                  )
                ],
              ),
              floatingActionButton: (!_addLoading)
                  ? FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        setState(() {
                          _addLoading = true;
                        });
                      },
                      tooltip: "Create a new student",
                      child: Icon(Icons.add),
                      elevation: 50.0,
                    )
                  : _createStudent(userProvider));
        } else {
          return Scaffold(
              appBar: AppBar(title: Text("Courses")),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    _getCourseDetails(userProvider),
                    Text("Loading course details")
                  ])));
        }
      } else {
        return Login();
      }
    });
  }

  Widget _list() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _studentList.length,
      itemBuilder: (context, index) {
        CourseMember student = _studentList[index];
        return UserInfo(courseMember: student, type: "Student");
      },
    );
  }

  Widget _createStudent(UserProvider userProvider) {
    userProvider.createStudent(widget.courseId).then((response) {
      if (!response.containsKey("error")) {
        CourseMember student = CourseMember(
            response["name"],
            response["username"],
            response["email"],
            response["id"],
            "no phone",
            "no city",
            "no country",
            "no birthdate");
        setState(() {
          _studentList.add(student);
          _addLoading = false;
        });
        return null;
      } else {
        setState(() {
          _addLoading = false;
        });
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

  Widget _getCourseDetails(UserProvider userProvider) {
    userProvider.getCourseDetails(widget.courseId).then((response) {
      if (!response.containsKey("error")) {
        _courseProfessor = CourseMember(
            response["professor"]["name"],
            response["professor"]["username"],
            response["professor"]["email"],
            response["professor"]["id"],
            response["professor"]["phone"],
            response["professor"]["city"],
            response["professor"]["country"],
            response["professor"]["birthday"]);
        List<dynamic> responseList = response["students"];
        for (var element in responseList) {
          CourseMember student = CourseMember(
              element["name"],
              element["username"],
              element["email"],
              element["id"],
              element["phone"],
              element["city"],
              element["country"],
              element["birthday"]);
          _studentList.add(student);
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
}
