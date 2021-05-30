import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'subj_choosing.dart';


ListTile makeListTile(String option,BuildContext Context) => new ListTile(
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
          option[0].toUpperCase() +
              option[1].toUpperCase(),
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
  title: new Text(
    option,
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    style: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  onTap: () {

    showDialog(
      context: Context,
      builder: (context) {
        var futureBuilder_slider = FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var prefs = snapshot.data;
                List<String> crs = prefs.getStringList("myList");
                if(crs==null){
                  crs = new List<String>();
                }
                List<String> Secs = prefs.getStringList("Secs");
                if(Secs==null){
                  Secs = new List<String>();
                }
                List<String> professors= new List<String>();
                String Course=Secs.elementAt(crs.indexOf(option));
                List<String> Sections= new List<String>();
                Sections=Course.split("/");
                for(int i=0;i<Sections.length;i++){
                  List<String> Params= new List<String>();
                  Params=Sections.elementAt(i).split(",");
                  if(professors.indexOf(Params[0])<0) {
                    professors.add(Params[0]);
                  }
                }
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Container(
                    height: 400.0,
                    width: 360.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(child: Text("Choose Professor", style: TextStyle(fontSize: 24,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),),),
                        Container(
                            height: 300,
                            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            child:
                            ScrollConfiguration(
                                behavior: ScrollBehavior(),
                                child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: Colors.amberAccent,
                                    child:new ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: professors.length,
                                      itemBuilder: (context, index) {
                                        return

                                          new ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10.0),
                                            title: new Text(
                                              professors[index],
                                              textAlign: TextAlign.left,
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            onTap: () {
                                              ammendPrefProf(option,professors[index]);
                                              Navigator.pop(context);
                                            },
                                          );
                                      },
                                    )
                                )
                            )

                        ),
//                        RaisedButton(
//                          child:
//                          Text("confirm",
//                              style: TextStyle(fontSize: 20, color: Colors.white)),
//                          onPressed: () {
//                            Navigator.pop(context);
//                          },
//                          color: Colors.blue,
//                          textColor: Color(0xeeeeeeee),
//                          //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                          splashColor: Colors.grey,
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.all(
//                                  Radius.circular(30.0))),
//                        ),
                      ],
                    ),
                  ),
                );
              }
              else if (snapshot.hasError) {
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

              return Container(
                  color: Color(0xeeeeeeee),
                  child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.redAccent,
                      ))
              );
            });
        return futureBuilder_slider;
      },
    );
  },
);

Card makeCard(String option,BuildContext Context) => Card(
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

    child: makeListTile(option,Context),

  ),
);


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

void clearState() async {
  List<String> myList=new List<String>();
  List<String> Sections=new List<String>();
  var prefs = await SharedPreferences.getInstance();
  //List<String> oldList=prefs.getStringList("myList");
  //List<String> newList=myList+oldList;
  await prefs.setStringList("myList", myList);
  await prefs.setStringList("Secs", Sections);

//  myList.add("foobar");
//
//  print(prefs.getStringList("myList")); // [foobar]
}

void ammendState(int index) async {
  var prefs = await SharedPreferences.getInstance();
  List<String> oldList=prefs.getStringList("myList");
  if(oldList==null){
    oldList = new List<String>();
  }
  List<String> oldSections=prefs.getStringList("Secs");
  if(oldSections==null){
    oldSections= new List<String>();
  }
  oldList.removeAt(index);
  oldSections.removeAt(index);
  await prefs.setStringList("myList", oldList);
  await prefs.setStringList("Secs", oldSections);
}

void ammendPrefProf(String Subject,String Prof) async {
  var prefs = await SharedPreferences.getInstance();
  List<String> oldList=prefs.getStringList("myList");
  if(oldList==null){
    oldList= new List<String>();
  }
  List<String> Sections_copy=prefs.getStringList("Secs_copy");
  if(Sections_copy==null){
    Sections_copy= new List<String>();
  }
  List<String> Secs=prefs.getStringList("Secs");
  if(Secs==null){
    Secs= new List<String>();
  }

  String Course=Sections_copy.elementAt(oldList.indexOf(Subject));

  if(Sections_copy.elementAt(oldList.indexOf(Subject)).indexOf(Prof)<0){
    Course=Secs.elementAt(oldList.indexOf(Subject));
  }


  List<String> Sections= new List<String>();
  List<String> new_Sections= new List<String>();
  Sections=Course.split("/");
  for(int i=0;i<Sections.length;i++){
    List<String> Params= new List<String>();
    Params=Sections.elementAt(i).split(",");
    if(Params[0]==Prof){
      new_Sections.add(Sections.elementAt(i));
    }
  }

  String all_sections;
  for(int j=0;j<new_Sections.length;j++){
    if(j==0){
      all_sections=new_Sections.elementAt(j);
    }
    else{
      all_sections=all_sections+"/"+new_Sections.elementAt(j);
    }
  }


  Sections_copy[oldList.indexOf(Subject)]=all_sections;
  //oldList.removeAt(index);
  await prefs.setStringList("myList", oldList);
  await prefs.setStringList("Secs_copy", Sections_copy);
}

Future<List<String>> getState() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("myList");
}

void Instance(SharedPreferences prefs) async{
  prefs= await SharedPreferences.getInstance();
}
class courses_list extends StatefulWidget {

  @override
  // TODO: implement session
  // TODO: implement session
  final User value;
  courses_list({Key key,this.value}): super(key:key);
  @override
  courses_list_state createState() => courses_list_state();
}


void writeState(String Option1,String Option2) async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString("Option1", Option1);
  await prefs.setString("Option2", Option2);
}

void checkWriteState() async {
  var prefs = await SharedPreferences.getInstance();
  String Option1 = prefs.getString("Option1");
  if(Option1==null){
    Option1="3";
  }
  String Option2 = prefs.getString("Option2");
  if(Option2==null){
    Option2="8";
  }
  await prefs.setString("Option1", Option1);
  await prefs.setString("Option2", Option2);
}



class courses_list_state extends State<courses_list> {
  SharedPreferences prefs;
  List<String> courses;
  double _lowerValue_option1 = 3;
  //double _upperValue_option1 = 20;
  double _lowerValue_option2 = 8;
  //double _upperValue_option2 = 12;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    var futureBuilder=FutureBuilder<List<String>>(
        future: getState(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return Container(
                color: Color(0xeeeeeeee),
                child:
                ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: Colors.amberAccent,
                        child:new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            /*return new Card(
                      //
                      //color: _selected[index] ? Colors.blue : null,
                      //             <-- Card widget
                      child:
                      new ListTile(
                        //leading: Icon(icons[index]),
                        title: new Text(snapshot.data[index]),
                        onTap: () {
                          setState(() {
                            //_selected[index] = !_selected[index];
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
                    );*/
                            //return makeCard(snapshot.data[index]);
                            final item=snapshot.data[index];
                            return Dismissible(
                              // Each Dismissible must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                              key: Key(snapshot.data[index]),
                              // Provide a function that tells the app
                              // what to do after an item has been swiped away.
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  ammendState(index);
                                  snapshot.data.removeAt(index);
                                });

                                // Then show a snackbar.
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text("\"$item\""+" dismissed")));
                              },
                              // Show a red background as the item is swiped away.
                              background: Container(color: Colors.red),
                              child: makeCard(snapshot.data[index],this.context),
                            );

                          },
                        )
                    )
                )
            );
          }
          else if (snapshot.hasError) {
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
          return CircularProgressIndicator();
        });



    final topAppBar = AppBar(
      elevation: 0.1,
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      backgroundColor: Colors.redAccent,
      title: Text(
        "Courses Cart",
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            var futureBuilder_slider = FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var prefs = snapshot.data;
                    String Option1 = prefs.getString("Option1");
                    print("Option1 = "+Option1);
                    if(Option1==null){
                      Option1="";
                    }

                    String Option2 = prefs.getString("Option2");
                    print("Option2 = "+Option2);
                    if(Option2==null){
                      Option2="";
                    }
                    if(Option1.length>0){
                      _lowerValue_option1=double.parse(Option1);
                    }
                    if(Option2.length>0){
                      _lowerValue_option2=double.parse(Option2);
                    }
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 16,
                      child: Container(
                        height: 400.0,
                        width: 360.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Center(child: Text("Options", style: TextStyle(fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),),),
                            SizedBox(height: 40),
                            Center(child: Text("Max Gap Size", style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),),),
                            Container(
                                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: FlutterSlider(
                                  //values: [3, 20],
                                  values: [_lowerValue_option1],
                                  ignoreSteps: [
                                    //FlutterSliderIgnoreSteps(from: 18000, to: 22000),
                                  ],
                                  max: 20,
                                  min: 3,
                                  step: 2,
                                  jump: true,
                                  trackBar: FlutterSliderTrackBar(
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black12,
                                      border: Border.all(width: 3, color: Colors.blue),
                                    ),
                                    activeTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.blue.withOpacity(0.5)
                                    ),
                                  ),
                                  tooltip: FlutterSliderTooltip(
                                    textStyle: TextStyle(
                                        fontSize: 17, color: Colors.lightBlue),
                                  ),
                                  handler: FlutterSliderHandler(
                                    decoration: BoxDecoration(),
                                    child: Material(
                                      type: MaterialType.canvas,
                                      color: Colors.amberAccent,
                                      elevation: 10,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.adjust,
                                            size: 25,
                                          )),
                                    ),
                                  ),
                                  rightHandler: FlutterSliderHandler(
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                  disabled: false,
                                  onDragging: (handlerIndex, lowerValue, upperValue) {
                                    _lowerValue_option1 = lowerValue;
                                    //_upperValue_option1 = upperValue;
                                    setState(() {});
                                  },
                                  onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                                    setState(() {
                                      writeState(_lowerValue_option1.toString(),_lowerValue_option2.toString());
                                    });
                                  },
                                )),
                            Center(child: Text("First Class Time", style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),),),

                            Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 20, right: 20, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: FlutterSlider(
                                  values: [_lowerValue_option2],
                                  ignoreSteps: [
                                    //FlutterSliderIgnoreSteps(from: 8000, to: 12000),
                                    //FlutterSliderIgnoreSteps(from: 18000, to: 22000),
                                  ],
                                  max: 12,
                                  min: 8,
                                  step: 0.5,
                                  jump: true,
                                  trackBar: FlutterSliderTrackBar(
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black12,
                                      border: Border.all(width: 3, color: Colors.blue),
                                    ),
                                    activeTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.blue.withOpacity(0.5)
                                    ),
                                  ),
                                  tooltip: FlutterSliderTooltip(
                                    textStyle: TextStyle(
                                        fontSize: 17, color: Colors.lightBlue),
                                  ),
                                  handler: FlutterSliderHandler(
                                    decoration: BoxDecoration(),
                                    child: Material(
                                      type: MaterialType.canvas,
                                      color: Colors.amberAccent,
                                      elevation: 10,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.adjust,
                                            size: 25,
                                          )),
                                    ),
                                  ),
                                  rightHandler: FlutterSliderHandler(
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                  disabled: false,
                                  onDragging: (handlerIndex, lowerValue, upperValue) {
                                    _lowerValue_option2 = lowerValue;
                                    //_upperValue_option2 = upperValue;
                                    setState(() {});
                                  },
                                )),
                            RaisedButton(
                              child:
                              Text("confirm",
                                  style: TextStyle(fontSize: 20, color: Colors.white)),
                              onPressed: () {
                                ///////////////////////////////
                                //setState(() {});
                                writeState(_lowerValue_option1.toString(),
                                    _lowerValue_option2.toString());
                                //print('$_lowerValue_option1'+" "+'$_lowerValue_option2');
                                Navigator.pop(context);
                              },
                              color: Colors.blue,
                              textColor: Color(0xeeeeeeee),
                              //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0))),
                            ),
//                    CupertinoSlider(
//                      value: _lowerValue_option1,
//                      min: 0.0,
//                      max: 100.0,
//                      onChanged: (value){
//                        setState(() {
//                          //_progress = value.roundToDouble();
//                          _lowerValue_option1=value.roundToDouble();
//                        });
//                      },
//                    ),
                          ],
                        ),
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
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

                  return Container(
                      color: Color(0xeeeeeeee),
                      child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.redAccent,
                          ))
                  );
                });
            showDialog(
              context: context,
              builder: (context) {
                return futureBuilder_slider;

//                  Dialog(
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//                  elevation: 16,
//                  child: Container(
//                    height: 400.0,
//                    width: 360.0,
//                    child: Column(
//                      children: <Widget>[
//                        SizedBox(height: 20),
//                        Center(child: Text("Options",style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),),),
//                        SizedBox(height: 40),
//                        Center(child: Text("Max Gap Size",style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold),),),
//                        Container(
//                            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
//                            alignment: Alignment.centerLeft,
//                            child: FlutterSlider(
//                              values: [3, 20],
//                              ignoreSteps: [
//                                //FlutterSliderIgnoreSteps(from: 8000, to: 12000),
//                                //FlutterSliderIgnoreSteps(from: 18000, to: 22000),
//                              ],
//                              max: 20,
//                              min: 3,
//                              step: 2,
//                              jump: true,
//                              trackBar: FlutterSliderTrackBar(
//                                inactiveTrackBar: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(20),
//                                  color: Colors.black12,
//                                  border: Border.all(width: 3, color: Colors.blue),
//                                ),
//                                activeTrackBar: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(4),
//                                    color: Colors.blue.withOpacity(0.5)
//                                ),
//                              ),
//                              tooltip: FlutterSliderTooltip(
//                                textStyle: TextStyle(fontSize: 17, color: Colors.lightBlue),
//                              ),
//                              handler: FlutterSliderHandler(
//                                decoration: BoxDecoration(),
//                                child: Material(
//                                  type: MaterialType.canvas,
//                                  color: Colors.amberAccent,
//                                  elevation: 10,
//                                  child: Container(
//                                      padding: EdgeInsets.all(5),
//                                      child: Icon(
//                                        Icons.adjust,
//                                        size: 25,
//                                      )),
//                                ),
//                              ),
//                              rightHandler: FlutterSliderHandler(
//                                child: Icon(
//                                  Icons.chevron_left,
//                                  color: Colors.red,
//                                  size: 24,
//                                ),
//                              ),
//                              disabled: false,
//                              onDragging: (handlerIndex, lowerValue, upperValue) {
//                                _lowerValue_option1 = lowerValue;
//                                _upperValue_option1  = upperValue;
//                                setState(() {});
//                              },
//                            )),
//                        Center(child: Text("First Class Time",style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold),),),
//                        Container(
//                            margin: EdgeInsets.only(top: 20, left: 20, right: 20,bottom: 10),
//                            alignment: Alignment.centerLeft,
//                            child: FlutterSlider(
//                              values: [8, 10, 12],
//                              ignoreSteps: [
//                                //FlutterSliderIgnoreSteps(from: 8000, to: 12000),
//                                //FlutterSliderIgnoreSteps(from: 18000, to: 22000),
//                              ],
//                              max: 12,
//                              min: 8,
//                              step: 0.5,
//                              jump: true,
//                              trackBar: FlutterSliderTrackBar(
//                                inactiveTrackBar: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(20),
//                                  color: Colors.black12,
//                                  border: Border.all(width: 3, color: Colors.blue),
//                                ),
//                                activeTrackBar: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(4),
//                                    color: Colors.blue.withOpacity(0.5)
//                                ),
//                              ),
//                              tooltip: FlutterSliderTooltip(
//                                textStyle: TextStyle(fontSize: 17, color: Colors.lightBlue),
//                              ),
//                              handler: FlutterSliderHandler(
//                                decoration: BoxDecoration(),
//                                child: Material(
//                                  type: MaterialType.canvas,
//                                  color: Colors.amberAccent,
//                                  elevation: 10,
//                                  child: Container(
//                                      padding: EdgeInsets.all(5),
//                                      child: Icon(
//                                        Icons.adjust,
//                                        size: 25,
//                                      )),
//                                ),
//                              ),
//                              rightHandler: FlutterSliderHandler(
//                                child: Icon(
//                                  Icons.chevron_left,
//                                  color: Colors.red,
//                                  size: 24,
//                                ),
//                              ),
//                              disabled: false,
//                              onDragging: (handlerIndex, lowerValue, upperValue) {
//                                _lowerValue_option2 = lowerValue;
//                                _upperValue_option2 = upperValue;
//                                setState(() {});
//                              },
//                            )),
//                        RaisedButton(
//                          child:
//                          Text("confirm",style: TextStyle(fontSize: 20,color: Colors.white)),
//                          onPressed: (){
//                            ///////////////////////////////
//                            //setState(() {});
//                            writeState(_lowerValue_option1.toString(), _lowerValue_option2.toString());
//                            //print('$_lowerValue_option1'+" "+'$_lowerValue_option2');
//                            Navigator.pop(context);
//
//                          },
//                          color: Colors.blue,
//                          textColor: Color(0xeeeeeeee),
//                          //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                          splashColor: Colors.grey,
//                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                        ),
//                      ],
//                    ),
//                  ),
//                );
              },
            );
          },
        )
      ],
    );

    return new Scaffold(
        appBar: topAppBar,
        body:
        Container(
          color: Color(0xeeeeeeee),
          child: Column(
            children: <Widget>[
              Container(
                  height: 400,
                  child: futureBuilder
              ),
              RaisedButton(
                child:
                Text("Generate Schedule",style: TextStyle(fontSize: 20)),
                onPressed: (){
                  checkWriteState();
                  Navigator.pushNamed(context, "/gen_sked");
                },
                color: Color(0xffffab40),
                textColor: Color(0xeeeeeeee),
                //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ),
              RaisedButton(
                child:
                Text("Add another course",style: TextStyle(fontSize: 20)),
                onPressed: (){
                  var count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                  //Navigator.popUntil(context, ModalRoute.withName('/subj_choosing'));
                },
                color: Color(0xffffab40),
                textColor: Color(0xeeeeeeee),
                //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ),
              RaisedButton(
                child:
                Text("Clear All",style: TextStyle(fontSize: 20)),
                onPressed: (){
                  setState(() {
                    clearState();
                  });

                },
                color: Color(0xffffab40),
                textColor: Color(0xeeeeeeee),
                //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ),
            ],
          ),
        )

    );
  }
}