import 'package:flutter/material.dart';
import 'package:simple_api_consumer_login/core/models/course.dart';
import '../pages/courseDetails.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({this.course});

  @override
  Widget build(BuildContext context) {
    String courseInfo = "Professor: ${course.courseProfessor}\n" +
        "Students: ${course.courseStudents}\n" +
        "Id: ${course.courseId}";
    return Card(
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.book),
            title: Text(course.courseName),
            subtitle: Text(courseInfo),
            isThreeLine: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CourseDetails(courseId: course.courseId))),
          )
        ]));
  }
}
