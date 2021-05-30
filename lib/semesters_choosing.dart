import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'Session.dart';
import 'subj_choosing.dart';

ListTile makeListTile(String option,String value, String Cookies, Client client, BuildContext context) => new ListTile(
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
  ),
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
    //print(values[options[index]]);
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
      new subj_choosing(
          value: User1(
              term_in: value,
              cookie: Cookies,
              client: client)),
    );
    Navigator.of(context).push(route);
  },
);

Card makeCard(String option,String value, String Cookies, Client client, BuildContext context) => Card(
  //
  elevation: 2.0,
  margin: new EdgeInsets.symmetric(
      horizontal: 10.0, vertical: 6.0),
  color: Colors.white,

  //             <-- Card widget
  child: Container(
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      color: Colors.white,
    ),

    child: makeListTile(option,value, Cookies, client, context),

  ),
);

class semester_choosing extends StatefulWidget {
  semester_choosing({Key key}) : super(key: key);

  @override
  _semester_choosing_state createState() => _semester_choosing_state();
}

class _semester_choosing_state extends State<semester_choosing> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var client = http.Client();
    var futureBuilder = FutureBuilder<http.Response>(
      future: client.get(
          "https://ssb-prod.ec.aucegypt.edu/PROD/bwckschd.p_disp_dyn_sched",
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Connection': 'keep-alive',
          }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String htmlResponse = snapshot.data.body;
          String Cookies = Session().updateCookie(snapshot.data);
          var document = parse(htmlResponse);
          var list = document.getElementsByTagName("OPTION").sublist(1);
          List<String> options = new List();
          Map<String, String> values = new Map();

          for (var item in list) {
            String year="";
            if(item.innerHtml.indexOf("20")>=0){
              year=item.innerHtml.substring(item.innerHtml.indexOf("20"),item.innerHtml.indexOf("20")+4);
            }

            if((item.innerHtml.indexOf("Fall")==0 || item.innerHtml.indexOf("Spring")==0 || item.innerHtml.indexOf("Summer")==0 || item.innerHtml.indexOf("Winter")==0) && item.innerHtml.indexOf("20")>=0 && int.parse(year)>=2019){
            options.add(item.innerHtml.replaceAll("amp;", ""));
            values[item.innerHtml.replaceAll("amp;", "")] = item.outerHtml.substring(
                item.outerHtml.indexOf("=\"") + 2,
                item.outerHtml.indexOf("\">"));
            }
          }
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
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return makeCard(options[index],values[options[index]],Cookies,client, context);
                  },
                      )
                  )
              )
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

    final topAppBar = AppBar(
      elevation: 0.1,
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      backgroundColor: Colors.redAccent,
      title: Text(
        "All Semesters List",
        style: TextStyle(color: Colors.white),
      ),
    );

    // TODO: implement build
    return new Scaffold(appBar: topAppBar, body: futureBuilder);
  }
}
