import 'package:flutter/material.dart';

import './models/auth.dart';

import './Screens/home.dart';
import './Screens/login.dart';

final auth = new AuthService();
bool _isAuthenticated = false;

void main() async {
  _isAuthenticated = await auth.checkIfAuthenticated();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    auth.checkIfAuthenticated().then((bool isAuthenticated) {
      _isAuthenticated = isAuthenticated;
    }).catchError((onError) {
      print('checkIfAuthenticated error: ${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/home': (BuildContext context) => Home(),
      },
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) {
              return _isAuthenticated ? Home() : Login();
            });
          case '/login':
            return MaterialPageRoute(builder: (_) => Login());
          case '/home':
            return MaterialPageRoute(builder: (_) => Home());
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => Home());
      },
    );
  }
}


