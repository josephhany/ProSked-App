import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class User{
  final String term_in,sel_subj,cookie;
  final http.Client client;
  const User(
      {
        this.term_in,
        this.sel_subj,
        this.cookie,
        this.client,
      }
      );
}

String parseProf(String innerHtml){
  if (innerHtml.indexOf("(<abbr") >= 0) {
    return innerHtml.substring(0, innerHtml.indexOf("(<abbr") - 1); //prof //modify here ++++
  }
  else if (innerHtml.indexOf("TBA") >= 0) {
    return "TBA";
  }
  else {
    return innerHtml; //prof //nodify here ++++
  }
}

String parseStartingTime(String innerHtml){
  String startingTime = innerHtml.split("-").elementAt(0);
  if (startingTime.indexOf("am") >= 0) {
    startingTime = startingTime.substring(0, startingTime.indexOf("am") - 1);
    double startTimeHour = num.parse(startingTime.split(":").elementAt(0)).toDouble();
    double startTimeMin = num.parse(startingTime.split(":").elementAt(1)).toDouble() / 60;
    startingTime = (startTimeHour + startTimeMin).toString();
  }
  else {
    startingTime = startingTime.substring(0, startingTime.indexOf("pm") - 1);
    double startTimeHour = num.parse(startingTime.split(":").elementAt(0)).toDouble();
    if(startTimeHour<12){
      startTimeHour=startTimeHour+12;
    }
    double startTimeMin = num.parse(startingTime.split(":").elementAt(1)).toDouble() / 60;
    startingTime = (startTimeHour + startTimeMin).toString();
  }

  return startingTime;
}

String parseEndingTime(String innerHtml){
  String endingTime = innerHtml.split("-").elementAt(1);
  if (endingTime.indexOf("am") >= 0) {
    endingTime = endingTime.substring(0, endingTime.indexOf("am") - 1);
    double endTimeHour = num.parse(endingTime.split(":").elementAt(0)).toDouble();
    double endTimeMin = num.parse(endingTime.split(":").elementAt(1)).toDouble() / 60;
    endingTime = (endTimeHour + endTimeMin).toString();
  }
  else {
    endingTime = endingTime.substring(0, endingTime.indexOf("pm") - 1);
    double endTimeHour = num.parse(endingTime.split(":").elementAt(0)).toDouble();
    if(endTimeHour<12){
      endTimeHour=endTimeHour+12;
    }
    double endTimeMin = num.parse(endingTime.split(":").elementAt(1)).toDouble() / 60;
    endingTime = (endTimeHour + endTimeMin).toString();
  }
  return endingTime;
}

void Instance(SharedPreferences prefs) async{
  prefs= await SharedPreferences.getInstance();
}

Future<bool> _saveList(SharedPreferences prefs,List<String> list) async {
  return await prefs.setStringList("key", list);
}

void writeState(List<String> myList,List<String> Sections) async {
  var prefs = await SharedPreferences.getInstance();
  List<String> oldList=prefs.getStringList("myList");
  if(oldList==null){
    oldList = new List<String>();
  }
  List<String> oldSecs=prefs.getStringList("Secs");
  if(oldSecs==null){
    oldSecs = new List<String>();
  }
  List<String> myList_filtered=new List<String>();
  List<String> Sections_filtered=new List<String>();

  if(oldList.length>0) {
    bool good=true;
    for (int i = 0; i < myList.length; i++) {
      good = true;
      int j=0;
      for (; j < oldList.length; j++) {
        if (myList.elementAt(i) == oldList.elementAt(j)) {
          print(myList.elementAt(i)+"=="+oldList.elementAt(j));
          good = false;
        }
      }
      if (good == true) {
        myList_filtered.add(myList.elementAt(i));
        Sections_filtered.add(Sections.elementAt(i));
      }
    }
  }
  else if(oldList.length==0){
    myList_filtered=myList;
    Sections_filtered=Sections;
  }

  List<String> newList=myList_filtered+oldList;
  List<String> newSecs=Sections_filtered+oldSecs;
  await prefs.setStringList("myList", newList);
  await prefs.setStringList("Secs", newSecs);
  await prefs.setStringList("Secs_copy", newSecs);

//  myList.add("foobar");
//
//  print(prefs.getStringList("myList")); // [foobar]
}

Future<List<String>> getState() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("myList");
}



class course_choosing extends StatefulWidget {

  @override
  // TODO: implement session
  // TODO: implement session
  final User value;
  List<String> Crs;
  List<String> Sec;
  List<bool> Sel;
  course_choosing({Key key,this.value}): super(key:key);
  @override
  _course_choosing_state createState() => _course_choosing_state();
}

class _course_choosing_state extends State<course_choosing> {

  List<bool> _selected;
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  int n=200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = List.generate(n, (i) => false);
  }
  @override
  Widget build(BuildContext context) {
    Instance(prefs);
    var futureBuilder=FutureBuilder<http.Response>(
      future: widget.value.client.post(
          "https://ssb-prod.ec.aucegypt.edu/PROD/crse_submit.submit_proc",
          body: 'term_in=' + '${widget.value.term_in}' +
              '&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=' +
              '${widget.value.sel_subj}' +
              '&sel_crse=&sel_title=&sel_schd=%25&sel_from_cred=&sel_to_cred=&sel_camp=%25&sel_levl=%25&sel_ptrm=%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a'
          , headers:
      {
        'Content-Type': 'application/x-www-form-urlencoded',
        //'Cookie': 'TESTID=set; _ga=GA1.2.604250996.1565571895; _gid=GA1.2.599836030.1577810488; _gcl_au=1.1.1687362477.1578059078; _fbp=fb.1.1578059078669.667869644; ${widget.value.cookie} accessibility=false; sghe_magellan_locale=en_US; sghe_magellan_username=;',
        'Cookie': '_ga=GA1.2.425633912.1578183703; sghe_magellan_username=; sghe_magellan_locale=en_US; AWSELB=E13769330A265C2842B9F1A687A25A73213E040C366842798BB06D9D2D972554590541FC430C87A584997500B41FEF782D99E6F8991BC74EADC851DF9332C79CE6CC2FE83C; _gid=GA1.2.525530560.1578312057; _gat_gtag_UA_107268303_1=1',
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String htmlResponse = snapshot.data.body;
          var document = parse(htmlResponse);
          var list = document.getElementsByClassName("dddefault");
          List<String> courses = new List();
          List<List<List<String>>> sections = new List<List<List<String>>>();

          String test;

          for (int i = 0; i <= (list.indexOf(list.last)); i += 17) {

            if(list[i + 7].outerHtml.indexOf("colspan")>=0){
              if(i+14>=list.indexOf(list.last)){
                break;
              }
              else{
                i=i+15;
              }
              //17+
              //15+
              //time->7 not 9
              //instructor-> 11 not --13
              //time baaa7 (8)

            }
            if ((courses.indexOf(list[i + 6].innerHtml.replaceAll("amp;", "")) == -1) && (list[i + 9].innerHtml.indexOf("-")>=0) && (list[i + 8].innerHtml.indexOf("&nbsp;")<0) && (list[i + 8].innerHtml.indexOf("TBA")<0) && (list[i + 6].innerHtml.indexOf("&nbsp;")<0)) {

              courses.add(list[i + 6].innerHtml.replaceAll("amp;", ""));
              var inner_list = new List<String>();

              inner_list.add(parseProf(list[i + 13].innerHtml).replaceAll("/", "-"));//professor
              inner_list.add(list[i + 6].innerHtml.replaceAll("amp;", "").replaceAll(",", "-").replaceAll("/", "-")); //course name
              inner_list.add(list[i + 8].innerHtml); //days

              test=parseStartingTime(list[i + 9].innerHtml);
              //test=list[i + 9].innerHtml;

              inner_list.add(parseStartingTime(list[i + 9].innerHtml)); //from (time) //modify here ++++
              inner_list.add(parseEndingTime(list[i + 9].innerHtml)); //to (time)  //modify here ++++
              inner_list.add(list[i + 9].innerHtml.split("-").elementAt(0)); //to (time)  //modify here ++++
              inner_list.add(list[i + 9].innerHtml.split("-").elementAt(1)); //to (time)  //modify here ++++
              inner_list.add(list[i].getElementsByTagName("a").elementAt(0).innerHtml); //to (time)  //modify here ++++
              inner_list.add(list[i + 3].innerHtml); //to (time)  //modify here ++++

              var listOflists = new List<List<String>>();
              listOflists.add(inner_list);
              sections.add(listOflists);
            }
            else if((list[i + 9].innerHtml.indexOf("-")>=0) && (list[i + 8].innerHtml.indexOf("&nbsp;")<0) && (list[i + 8].innerHtml.indexOf("TBA")<0) && (list[i + 6].innerHtml.indexOf("&nbsp;")<0)){

              var inner_list = new List<String>();
              inner_list.add(parseProf(list[i + 13].innerHtml).replaceAll("/", "-"));//professor
              inner_list.add(list[i + 6].innerHtml.replaceAll("amp;", "").replaceAll(",", "-").replaceAll("/", "-")); //course name
              inner_list.add(list[i + 8].innerHtml); //days
              inner_list.add(parseStartingTime(list[i + 9].innerHtml)); //from (time) //modify here ++++
              inner_list.add(parseEndingTime(list[i + 9].innerHtml)); //to (time)  //modify here ++++
              inner_list.add(list[i + 9].innerHtml.split("-").elementAt(0)); //to (time)  //modify here ++++
              inner_list.add(list[i + 9].innerHtml.split("-").elementAt(1)); //to (time)  //modify here ++++
              inner_list.add(list[i].getElementsByTagName("a").elementAt(0).innerHtml); //to (time)  //modify here ++++
              inner_list.add(list[i + 3].innerHtml); //to (time)  //modify here ++++
              sections.elementAt(courses.indexOf(list[i + 6].innerHtml.replaceAll("amp;", ""))).add(inner_list);
            }
          }

          List<String> Secs=new List<String> ();

          for(int i=0;i<sections.length;i++){
            String element;
            for(int j=0;j<sections[i].length;j++){
              for(int k=0;k<sections[i][j].length;k++){
                if(sections[i][j][k]!=null) {
                  String str2=sections[i][j][k];
                  if(j==0 && k==0){
                    element = '$str2';
                  }
                  else {
                    element = '$element' '$str2';
                  }
                  //element = element + sections[i][j][k];
                }
                if(k!=(sections[i][j].length)-1) {
                  element='$element' ',';
                  //element = element + ",";
                }
              }
              if(j!=(sections[i].length)-1) {
                element='$element' '/';
                //element = element + "/";
              }
            }
            Secs.add(element);
          }

          //_saveList(prefs,courses);
          //writeState(courses);
          n = courses.length;
          widget.Crs = courses;
          widget.Sec = Secs;


          /*
            SingleChildScrollView(
            child: Text(list[6].innerHtml+'\n'+list[6+17].innerHtml+'\n'+list[6+17+17].innerHtml),
          );
          */
          //Text(test);

          return Container(
            color: Color(0xeeeeeeee),

            child: Column(
              children: <Widget>[

                /*Container(
                  height: 500,
                  child: futureBuilder
              ),*/

                Expanded(
                  child:
                  ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: Colors.amberAccent,
                          child: new ListView.builder(
                            physics: ClampingScrollPhysics(),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              return new Card(
                                //
                                //
                                elevation: 2.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                color: _selected[index] ? Colors.amberAccent : null,

                                //             <-- Card widget
                                child: Container(
                                  //decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                  //decoration: BoxDecoration(color: Colors.white),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    //color: Color(0xeeeeeeff),
                                    color: _selected[index] ? Colors.amberAccent : null,
                                  ),

                                  child: new ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    leading: Container(
                                        padding: EdgeInsets.only(right: 12.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(
                                                    width: 1.0, color: Colors.white24))),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.redAccent,
                                          child: Text(
                                            courses[index][0].toUpperCase() +
                                                courses[index][1].toUpperCase(),
                                            style: TextStyle(
                                              //fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amberAccent,
                                            ),
                                          ),
                                        )
                                      //Icon(Icons.autorenew, color: Color(0xffffab40)),
                                    ),
                                    //leading: Icon(icons[index]),
                                    title: new Text(courses[index],style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),),
                                    onTap: () {
                                      setState(() {
                                        _selected[index] = !_selected[index];
                                        widget.Sel=_selected;
                                      });

                                      //print(values[options[index]]);
//                        var route = new MaterialPageRoute(
//                          builder: (BuildContext context) =>
//                          new course_choosing(
//                              //value: values[options[index]].toString()//////////////////////////
//                          ),
//                        );
//                        Navigator.of(context).push(route);
                                    },
                                  ),

                                ),


                              );
                            },
                          )
                      )),
                ),
                SizedBox(height: 5),
                Center(child: RaisedButton(
                  child:
                  Text("Add Course",style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    List<String> sel_crs=new List<String>();
                    List<String> sel_secs=new List<String>();
                    for(int i=0;i<widget.Crs.length;i++){
                      if(widget.Sel[i]==true){
                        sel_crs.add(widget.Crs.elementAt(i));
                        sel_secs.add(widget.Sec.elementAt(i));
                      }
                    }
                    writeState(sel_crs,sel_secs);

//                      var futureBuilder=FutureBuilder<http.Response>(
//                          future: ,
//                          builder: (context, snapshot) {
//                            if (snapshot.hasData) {}
//                            else {}
//                          });

                    Navigator.pushNamed(context, "/courses_list");
                  },
                  color: Color(0xffffab40),
                  textColor: Color(0xeeeeeeee),
                  //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                ),),
                SizedBox(height: 5),
              ],
            ),





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
            child:
            Center(
                child:
                CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                )
            )
        );
      },
    );
    // TODO: implement build

    final topAppBar = AppBar(
      elevation: 0.1,
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      backgroundColor: Colors.redAccent,
      title: Text(
        "Course Choosing",
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
        appBar: topAppBar,
        body: futureBuilder
    );
  }
}