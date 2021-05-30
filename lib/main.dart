import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
import 'University_Screen.dart';
import 'semesters_choosing.dart';
import 'course_choosing.dart';
import 'courses_list.dart';
import 'Schedule.dart';
import 'generated_schedule.dart';
import 'subj_choosing.dart';
import 'Splash_Screen.dart';

var routes = <String, WidgetBuilder>{
  "/sem_list": (BuildContext context) => semester_choosing(),
  "/course":(BuildContext context) => course_choosing(),
  "/courses_list":(BuildContext context) => courses_list(),
  "/gen_sked": (BuildContext context) => generated_schedule(),
  "/subj_choosing": (BuildContext context) => subj_choosing(),
  "/university_screen": (BuildContext context) => university_screen(),
};


void main() {


  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Complete TextField Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(),
      routes: routes,
    );
  }
}