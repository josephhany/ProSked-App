import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Schedule.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Container MakeContainer(String day)=> new Container(
    margin: const EdgeInsets.only(top: 0.0, bottom: 3.0),
//padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
//borderRadius: BorderRadius.all(Radius.circular(8.0)),
      color: Colors.deepOrangeAccent,
    ),
    child:Padding(padding: EdgeInsets.only(top: 7,bottom:7),child: Center(child:Text(day,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),)),)//(0xeeeeeeee)
);

ListTile makeListTile(String start_time,String end_time, String course_name,String professor_name,String CRN,String Section) => new ListTile(
    contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(
                    width: 1.0, color: Colors.white24))),
        child: Column(children: <Widget>[
          Text(start_time),
          Text(end_time),
        ],)

    ),
    title:
    Column(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          course_name,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: 3),
        new Text(
          professor_name,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 14,
            //fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 3),
        Row(children: <Widget>[
          new Text(
            "CRN: "+CRN,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 14,
              //fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
          new Text(
            "Section: "+Section,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 14,
              //fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],)

      ],)
);

Card makeCard(String start_time,String end_time, String course_name,String professor_name,String CRN,String Section) => Card(
  //
  elevation: 2.0,
  margin: new EdgeInsets.symmetric(
      horizontal: 10.0, vertical: 6.0),
  color: Colors.white,

  //             <-- Card widget
  child: Container(
    //decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    //decoration: BoxDecoration(color: Colors.white),
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //color: Color(0xeeeeeeff),
      color: Colors.white,
    ),

    child: makeListTile(start_time,end_time, course_name,professor_name,CRN,Section),

  ),
);


ListTile makeHeaderListTile(String day) => new ListTile(
    contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0, vertical: 10.0),
    title:
    Column(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          day,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ],)
);

Card makeHeaderCard(String day) => Card(
  //
  elevation: 2.0,
  margin: new EdgeInsets.symmetric(
      horizontal: 10.0, vertical: 6.0),
  color: Colors.white,

  //             <-- Card widget
  child: Container(
    //decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    //decoration: BoxDecoration(color: Colors.white),
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //color: Color(0xeeeeeeff),
      color: Colors.white,
    ),

    child: makeHeaderCard(day),

  ),
);


class generated_schedule extends StatefulWidget {
  @override
  // TODO: implement session
  // TODO: implement session
  generated_schedule({Key key}) : super(key: key);

  @override
  generated_schedule_state createState() => generated_schedule_state();
}

class generated_schedule_state extends State<generated_schedule> {
  Algorithm genetic_algorithm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genetic_algorithm = new Algorithm().GetInstance;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var futureBuilder = FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var prefs = snapshot.data;
          List<String> crs = prefs.getStringList("myList");
          if(crs==null){
            crs = new List<String>();
          }
          List<String> Secs = prefs.getStringList("Secs_copy");
          if(Secs==null){
            Secs = new List<String>();
          }
          String Option1 = prefs.getString("Option1");
          if(Option1==null){
            Option1 = "";
          }
          String Option2= prefs.getString("Option2");
          if(Option2==null){
            Option2 = "";
          }
          //if(objInd==0) {

          fillObj(crs, Secs,Option1,Option2);


          //  objInd++;
          //}
          Algorithm genetic_algorithm = new Algorithm().GetInstance;
          genetic_algorithm.Start();
          if(genetic_algorithm.GetBestChromosome==null){
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(Icons.announcement,size: 100,),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text("Sorry there is no schedule\nwith these options",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),textAlign: TextAlign.center,),
                  )

                ],
              ),);
            //return Text("Sorry there is no schedules by these options");
          }

          Map<CourseClass, List<int>> final_schedule = genetic_algorithm.GetBestChromosome.GetClasses;


//          String final_result = "";
//          for (int i = 0; i < final_schedule.keys.toList().length; i++) {
//            final_result = final_result + final_schedule.keys.toList().elementAt(i).getCourseName + " " + final_schedule.keys.toList().elementAt(i).GetProfessor + " " + final_schedule.keys.toList().elementAt(i).getAvailableDays + " " + (final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12).toString() + "\n";}
//          final_result = final_result + "\n" + genetic_algorithm.GetBestChromosome.GetGapSize; //obj.GetGapSize.toString();
//          bool we_are_good_to_go = true;
//          for (int i = (DAYS_NUM * DAY_HOURS) - 1; i >= 0; i--) {
//            if (genetic_algorithm.GetBestChromosome.GetSlots[i].length > 1) {
//              we_are_good_to_go = false;
//            }
//          }
//          final_result = final_result + "\n" + we_are_good_to_go.toString(); //obj.GetGapSize.toString();
//          return SingleChildScrollView(child: Text(final_result));

          //_____________________________________________

          Map<double,int> sunday_classes=new Map<double,int>();
          Map<double,int> monday_classes=new Map<double,int>();
          Map<double,int> tuesday_classes=new Map<double,int>();
          Map<double,int> wednesday_classes=new Map<double,int>();
          Map<double,int> thursday_classes=new Map<double,int>();

          for (int i = 0; i < final_schedule.keys.toList().length; i++) {
            if (final_schedule.keys.toList().elementAt(i).getAvailableDays.indexOf("U")>=0) {
              print("Sunday: "+(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12).toString()+"->"+final_schedule.keys.toList().elementAt(i).getCourseName);
              sunday_classes[(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12)]=i;
            }
            if (final_schedule.keys.toList().elementAt(i).getAvailableDays.indexOf("M")>=0) {
              print("Monday: "+(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12).toString()+"->"+final_schedule.keys.toList().elementAt(i).getCourseName);
              monday_classes[(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12)]=i;
            }
            if (final_schedule.keys.toList().elementAt(i).getAvailableDays.indexOf("T")>=0) {
              print("Tuesday: "+(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12).toString()+"->"+final_schedule.keys.toList().elementAt(i).getCourseName);
              tuesday_classes[(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12)]=i;
            }
            if (final_schedule.keys.toList().elementAt(i).getAvailableDays.indexOf("W")>=0) {
              print("Wednesday: "+(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12).toString()+"->"+final_schedule.keys.toList().elementAt(i).getCourseName);
              wednesday_classes[(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12)]=i;
            }
            if (final_schedule.keys.toList().elementAt(i).getAvailableDays.indexOf("R")>=0) {
              print("Thursday: "+(final_schedule.keys.elementAt(i).getAvailableTimes / 12).toString()+"->"+final_schedule.keys.toList().elementAt(i).getCourseName);
              thursday_classes[(final_schedule.keys.toList().elementAt(i).getAvailableTimes / 12)]=i;
            }
          }
          sunday_classes.keys.toList().sort();
          monday_classes.keys.toList().sort();
          tuesday_classes.keys.toList().sort();
          wednesday_classes.keys.toList().sort();
          thursday_classes.keys.toList().sort();

          return ListView(
            children: <Widget>[
              //Expanded(child: makeHeaderCard("Sunday"),)
              //makeHeaderListTile("Sunday"),
              MakeContainer("Sunday"),
              //Center(child:Text("Sunday")),
              new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: sunday_classes.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<double> times=sunday_classes.keys.toList();
                  times.sort();
                  List<int> day_index=new List<int>();
                  for(int i=0;i<sunday_classes.length;i++){
                    day_index.add(sunday_classes[times.elementAt(i)]);
                  }
//                  double start_time=final_schedule.keys.toList().elementAt(sunday_classes.values.toList().elementAt(index)).getAvailableTimes/12;
//                  double end_time=start_time+final_schedule.keys.toList().elementAt(sunday_classes.values.toList().elementAt(index)).GetDuration/12;
                  String start_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getStartTime;
                  String end_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getEndTime;
                  String course_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getCourseName;
                  String professor_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetProfessor;
                  String CRN=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetCRN;
                  String Section=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetSection;
                  return makeCard(start_time.toString(),end_time.toString(),course_name,professor_name,CRN,Section);
                },
              ),
              MakeContainer("Monday"),
              //Center(child:Text("Monday")),
              new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: monday_classes.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  List<double> times=monday_classes.keys.toList();
                  times.sort();
                  List<int> day_index=new List<int>();
                  for(int i=0;i<monday_classes.length;i++){
                    day_index.add(monday_classes[times.elementAt(i)]);
                  }

                  String start_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getStartTime;
                  String end_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getEndTime;
                  String course_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getCourseName;
                  String professor_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetProfessor;
                  String CRN=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetCRN;
                  String Section=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetSection;
                  return makeCard(start_time.toString(),end_time.toString(),course_name,professor_name,CRN,Section);
                },
              ),
              MakeContainer("Tuesday"),
              //Center(child:Text("Tuesday")),
              new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: tuesday_classes.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<double> times=tuesday_classes.keys.toList();
                  times.sort();
                  List<int> day_index=new List<int>();
                  for(int i=0;i<tuesday_classes.length;i++){
                    day_index.add(tuesday_classes[times.elementAt(i)]);
                  }
                  String start_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getStartTime;
                  String end_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getEndTime;
                  String course_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getCourseName;
                  String professor_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetProfessor;
                  String CRN=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetCRN;
                  String Section=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetSection;
                  return makeCard(start_time.toString(),end_time.toString(),course_name,professor_name,CRN,Section);
                },
              ),
              MakeContainer("Wednesday"),
              //Center(child:Text("Wednesday")),
              new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: wednesday_classes.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<double> times=wednesday_classes.keys.toList();
                  times.sort();
                  List<int> day_index=new List<int>();
                  for(int i=0;i<wednesday_classes.length;i++){
                    day_index.add(wednesday_classes[times.elementAt(i)]);
                  }
                  String start_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getStartTime;
                  String end_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getEndTime;
                  String course_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getCourseName;
                  String professor_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetProfessor;
                  String CRN=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetCRN;
                  String Section=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetSection;
                  return makeCard(start_time.toString(),end_time.toString(),course_name,professor_name,CRN,Section);
                },
              ),
              MakeContainer("Thursday"),
              //Center(child:Text("Thursday")),
              new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: thursday_classes.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<double> times=thursday_classes.keys.toList();
                  times.sort();
                  List<int> day_index=new List<int>();
                  for(int i=0;i<thursday_classes.length;i++){
                    day_index.add(thursday_classes[times.elementAt(i)]);
                  }
                  String start_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getStartTime;
                  String end_time=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getEndTime;
                  String course_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).getCourseName;
                  String professor_name=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetProfessor;
                  String CRN=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetCRN;
                  String Section=final_schedule.keys.toList().elementAt(day_index.elementAt(index)).GetSection;
                  return makeCard(start_time.toString(),end_time.toString(),course_name,professor_name,CRN,Section);
                },
              ),
            ],

          );


        } else if (snapshot.hasError) {
          if(snapshot.error.toString().indexOf("SocketException")>=0){
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(Icons.signal_wifi_off,size: 100,),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text("No Internet Connection",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  )

                ],
              ),);
          }
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Icon(Icons.error,size: 100,),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text("We are trying to fix this error",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                )

              ],
            ),);
        }
        // By default, show a loading spinner.
        return Container(
            color: Color(0xeeeeeeee),
            child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                )));
      },
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      backgroundColor: Colors.redAccent,
      title: Text(
        "Generated Schedule",
        style: TextStyle(color: Colors.white),
      ),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.list),
//          onPressed: () {},
//        )
//      ],
    );

    return new Scaffold(
      backgroundColor: Color(0xeeeeeeee),
      appBar: topAppBar,
      body: futureBuilder,
    );
  }
}
