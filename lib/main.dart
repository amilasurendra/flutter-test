import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fb_events/event_list.dart';
import 'package:fb_events/model/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FB Events',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'FB Events'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  bool isLoggedIn = false;
  var profileData;
  var events;
  var facebookLoginResult;
  
  void onLoginStatusChanged(bool isLoggedIn, var profileData, var facebookLoginResult) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
      this.facebookLoginResult = facebookLoginResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Events"),
        ),
        body: Container(
          child: isLoggedIn
              ? FutureBuilder<List<Event>>(
                future: fetchEvents(http.Client(), facebookLoginResult),
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData ? EventList(snapshot.data) : Center(child:CircularProgressIndicator());
                }
              )
              : RaisedButton(
                  child: Text("Click to Login"),
                  onPressed: () => initiateFacebookLogin(),
                ),
        ),
      ),
    );
  }


 Future<List<Event>> fetchEvents(http.Client client, FacebookLoginResult facebookLoginResult) async {

  final response = await client.get('https://graph.facebook.com/v2.12/me/events?access_token=${facebookLoginResult.accessToken.token}');
 
  final parsed = json.decode(response.body);
 
  return parsed['data'].map<Event>((json) => Event.fromJSON(json)).toList();
}


  void initiateFacebookLogin() async {

    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile', 'user_events']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false, null, null);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false, null, null);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");

        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');


        var profile = json.decode(graphResponse.body);

        print(profile.toString());

        onLoginStatusChanged(true, profile, facebookLoginResult);

        break;
    }
  }
}
