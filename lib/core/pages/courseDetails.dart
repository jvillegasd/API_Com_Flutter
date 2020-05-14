import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_api_consumer_login/core/providers/userProvider.dart';
import '../pages/login.dart';
import '../widgets/dialogMessage.dart';
import '../models/student.dart';
import '../models/professor.dart';
import '../widgets/userInfo.dart';

class CourseDetails extends StatefulWidget {
  int courseId;

  CourseDetails({this.courseId});

  CourseDetailsState createState() => CourseDetailsState();
}

class CourseDetailsState extends State<CourseDetails> {
  bool _isLoading = true;
  Professor _courseProfessor;
  List<Student> _studentList = new List<Student>();

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
                UserInfo(
                  userId: _courseProfessor.id,
                  userEmail: _courseProfessor.email,
                  userFullname: _courseProfessor.name,
                  username: _courseProfessor.username,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text("Student list"),
                      _list()
                    ],
                  ),
                )
              ],
            )
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Courses")),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  _getCourseDetails(userProvider),
                  Text("Loading course details")
                ])),
          );
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
        Student student = _studentList[index];
        return UserInfo(userId: student.id, userEmail: student.email, userFullname: student.name, username: student.username);
      },
    );
  }

  Widget _getCourseDetails(UserProvider userProvider) {
    userProvider.getCourseDetails(widget.courseId).then((response) {
      if (!response.containsKey("error")) {
        _courseProfessor = Professor(
            response["professor"]["name"],
            response["professor"]["username"],
            response["professor"]["email"],
            response["professor"]["id"]);
        List<dynamic> responseList = response["students"];
        for (var element in responseList) {
          Student student = Student(element["name"], element["username"],
              element["email"], element["id"]);
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
