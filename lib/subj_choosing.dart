import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom_parsing.dart' ;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:requests/requests.dart';
import 'Session.dart';
import 'course_choosing.dart';

ListTile makeListTile(String option,String value, String Cookies, Client client, BuildContext context,String term_in) => new ListTile(
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
    //print(values[options[index]]);
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
      new course_choosing(
        value:
        new User(
          term_in : '${term_in}',
          sel_subj: value.toString(),
          cookie: '${Cookies}'.substring(0,'${Cookies}'.indexOf(';')+1),
          client: client,
        ),

      ),
    );
    Navigator.of(context).push(route);
  },
);

Card makeCard(String option,String value, String Cookies, Client client, BuildContext context,String term_in) => Card(
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

    child: makeListTile(option,value, Cookies, client, context,term_in),

  ),
);


class User1{
  final String term_in,cookie;
  final http.Client client;
  const User1(
      {
        this.term_in,
        this.cookie,
        this.client
      }
      );
}


class subj_choosing extends StatefulWidget {

  @override
  // TODO: implement session
  // TODO: implement session
  final User1 value;
  subj_choosing ({Key key,this.value}): super(key:key);
  @override
  _subj_choosing_state createState() => _subj_choosing_state();
}

class _subj_choosing_state extends State<subj_choosing > {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var futureBuilder=FutureBuilder<http.Response>(
      future: widget.value.client.post(
          "https://ssb-prod.ec.aucegypt.edu/PROD/bwckgens.p_proc_term_date",body: {'p_calling_proc':'bwckschd.p_disp_dyn_sched','p_term':'${widget.value.term_in}'},
          headers:{
            'Content-Type': 'application/x-www-form-urlencoded',
            'Connection': 'keep-alive',
            'Referer': 'https://ssb-prod.ec.aucegypt.edu/PROD/bwckschd.p_disp_dyn_sched',
            }),

      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String htmlResponse = snapshot.data.body.substring(snapshot.data.body.indexOf("<select name=\"sel_subj\""),snapshot.data.body.indexOf("</select>"));
          var document = parse(htmlResponse);
          var list = document.getElementsByTagName("OPTION").sublist(1);
          List<String> options = new List();
          Map<String, String> values = new Map();

          for (var item in list) {
            options.add(item.innerHtml.replaceAll("amp;", ""));
            values[item.innerHtml.replaceAll("amp;", "")] = item.outerHtml.substring(
                item.outerHtml.indexOf("=\"") + 2,
                item.outerHtml.indexOf("\">"));
          }
          return
            Container(
                color: Color(0xeeeeeeee),
                child:

                ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: Colors.amberAccent,
                        child:new ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return makeCard(options[index],values[options[index]],'${widget.value.cookie}',widget.value.client, context,'${widget.value.term_in}');
                  },
                )
                    ))
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
        "Subject Choosing",
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
        body:
        futureBuilder);
  }
}