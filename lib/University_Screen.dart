import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';


DateTime currentBackPressTime;


void clearState() async {
  List<String> myList=new List<String>();
  List<String> Sections=new List<String>();
  var prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("myList", myList);
  await prefs.setStringList("Secs", Sections);
}


class university_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _university_screen();
  }
}

class _university_screen extends State<university_screen> {
  //String dropdownValue="hello";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement build
    var client = http.Client();
    var futureBuilder = FutureBuilder<http.Response>(
      future: client.get("https://us-central1-prosked-8f46a.cloudfunctions.net/version1", headers: {}),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.body.toString());
          if(snapshot.data.body.toString().indexOf("0")>=0){
            return new WillPopScope(
                child:
                Scaffold(
                    backgroundColor: Colors.redAccent,
                    body: new Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        padding: EdgeInsets.fromLTRB(70, 80, 70, 0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                        ),
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Center(child: uniIcon()),
                                    Text(
                                      'University',
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFd0d0),
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Color(0xeeeeeeff),
                                        ),
                                        child:DropDown_1()
                                    ),

                                    Text(
                                      'Class standing',
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFd0d0),
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Color(0xeeeeeeff),
                                        ),
                                        child:DropDown_2()
                                    ),
                                    RaisedButton(
                                      child:
                                      Text("Next",style: TextStyle(fontSize: 20)),
                                      onPressed: (){
                                        Navigator.pushNamed(context, "/sem_list");
                                      },
                                      color: Color(0xffffab40),
                                      textColor: Color(0xeeeeeeee),
                                      //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      splashColor: Colors.grey,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                    ),

                                  ]),
                              RaisedButton(
                                child:
                                SizedBox.fromSize(size: Size(120, 40),child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Icon(Icons.info_outline),Text(" About the App",style: TextStyle(fontSize: 14))],),)

                                ,
                                onPressed: (){

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40)),
                                        elevation: 16,
                                        child:
                                        Center(child:
                                        Container(
                                          height: 450.0,
                                          width: 360.0,
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox(height: 20),
                                              Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[SizedBox(width: 20,),
                                                new IconButton(
                                                  icon: new Icon(Icons.close,color: Colors.black,),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                )
                                                ,],),
                                              Container(width: 270,child:
                                              Column(crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[SizedBox(height: 45),Text("This app was developed and designed by Joseph Hany, a creative coder who loves to develop mobile applications in his free time for the sake of helping others.\n\nProSked App is a Scheduling app which allows students to generate more efficient class schedules in a few minutes.\n\n If you have any suggestions concerning additions or bugs found in the app, please email me at", style: TextStyle(
                                                  fontSize: 19,
                                                  color: Colors.black,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                                  textAlign: TextAlign.center,
                                                ),Text("proskedapp@gmail.com", style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold), textAlign: TextAlign.center,)],)
                                                ,),

                                            ],
                                          ),
                                        ),
                                      )
                                      );
                                    },
                                  );

                                },
                                //onPressed: ()=> Navigator.pushNamed(context, "/myapp"),
                                color: Colors.brown,
                                textColor: Color(0xeeeeeeee),
                                //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                splashColor: Colors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              )
                            ]
                        )
                    )),
                onWillPop: (){SystemNavigator.pop();}
            );
          }
          else if(snapshot.data.body.toString().indexOf("1")>=0){
            return new WillPopScope(
                child:
                Scaffold(
                    backgroundColor: Colors.redAccent,
                    body: new Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        padding: EdgeInsets.fromLTRB(70, 80, 70, 0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                        ),
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              SizedBox(height: 70),
                              Center(
                                child: Icon(Icons.update,color: Colors.white,size: 200,),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text("Please update the app to continue...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),),
                              )
                            ]
                        )
                    )),
                onWillPop: (){SystemNavigator.pop();}
            );
          }
          else if(snapshot.data.body.toString().indexOf("2")>=0){
            return new WillPopScope(
                child:
                Scaffold(
                    backgroundColor: Colors.redAccent,
                    body: new Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        padding: EdgeInsets.fromLTRB(70, 80, 70, 0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                        ),
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              SizedBox(height: 50),
                              Center(
                                child: Icon(Icons.update,color: Colors.white,size: 200,),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text("We are updating the app for a better user experience.\n\nThank you for your patience.",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),),
                              )
                            ]
                        )
                    )),
                onWillPop: (){SystemNavigator.pop();}
            );
          }
        } else if (snapshot.hasError) {
          if(snapshot.error.toString().indexOf("SocketException")>=0){

            return new WillPopScope(
              child:
              Scaffold(
                backgroundColor: Colors.redAccent,
                body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(Icons.signal_wifi_off,color: Colors.white,size: 100,),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text("No Internet Connection",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                  )

                ],
              ),)));
          }

          return new WillPopScope(
              child:
              Scaffold(
                  backgroundColor: Colors.redAccent,
                  body:
            Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Icon(Icons.error,size: 100,color: Colors.white,),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text("We are trying to fix this error",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                )

              ],
            ),)));
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

    //return futureBuilder;
    return new WillPopScope(
        child:
        Scaffold(
            backgroundColor: Colors.redAccent,
            body: new Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                padding: EdgeInsets.fromLTRB(70, 80, 70, 0),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(child: uniIcon()),
                            Text(
                              'University',
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFd0d0),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  color: Color(0xeeeeeeff),
                                ),
                                child:DropDown_1()
                            ),

                            Text(
                              'Class standing',
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFd0d0),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  color: Color(0xeeeeeeff),
                                ),
                                child:DropDown_2()
                            ),
                            RaisedButton(
                              child:
                              Text("Next",style: TextStyle(fontSize: 20)),
                              onPressed: (){
                                Navigator.pushNamed(context, "/sem_list");
                              },
                              color: Color(0xffffab40),
                              textColor: Color(0xeeeeeeee),
                              //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                            ),

                          ]),
                      RaisedButton(
                        child:
                        SizedBox.fromSize(size: Size(120, 40),child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Icon(Icons.info_outline),Text(" About the App",style: TextStyle(fontSize: 14))],),)

                        ,
                        onPressed: (){

                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
                                  height: 450.0,
                                  width: 360.0,
                                  child: Stack(
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[SizedBox(width: 20,),
                                        new IconButton(
                                          icon: new Icon(Icons.close,color: Colors.black,),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        )
                                        ,],),
                                      Container(width: 270,child:
                                      Column(crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[SizedBox(height: 45),Text("This app was developed and designed by Joseph Hany, a creative coder who loves to develop mobile applications in his free time for the sake of helping others.\n\nProSked App is a Scheduling app which allows students to generate more efficient class schedules in a few minutes.\n\n If you have any suggestions concerning additions or bugs found in the app, please email me at", style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold
                                        ),
                                          textAlign: TextAlign.center,
                                        ),Text("proskedapp@gmail.com", style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold), textAlign: TextAlign.center,)],)
                                        ,),

                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                        },
                        //onPressed: ()=> Navigator.pushNamed(context, "/myapp"),
                        color: Colors.brown,
                        textColor: Color(0xeeeeeeee),
                        //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      )
                    ]
                )
            )),
        onWillPop: (){SystemNavigator.pop();}
    );

  }
}

class uniIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/unipic.png');
    Image image = Image(
      image: assetImage, /*height: 450,width: 450*/);
    return Container(child: image);
  }
}

/*
Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        ListView(children: <Widget>[
          // First element
          ListTile(
            title:
 */



class DropDown_1 extends StatefulWidget {
  DropDown_1({Key key}) : super(key: key);

  @override
  _DropDown_1_State createState() => _DropDown_1_State();
}
class _DropDown_1_State extends State<DropDown_1> {
  String dropdownValue = 'AUC';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
//      underline: Container(
//        height: 2,
//        color: Colors.black,
//      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['AUC']//'University Name',
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDown_2 extends StatefulWidget {
  DropDown_2({Key key}) : super(key: key);

  @override
  _DropDown_2_State createState() => _DropDown_2_State();
}
class _DropDown_2_State extends State<DropDown_2> {
  String dropdownValue = 'Freshman';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
//      underline: Container(
//        height: 2,
//        color: Colors.black,
//      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Freshman','Sophomore','Junior','Senior','Graduating Senior']//'Profession',
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}