import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/contacts_page.dart';
import 'login_page.dart';
import 'contacts_page.dart';
import 'contacts_list_page.dart';

void main() {
  runApp(MyApp());
}

const iOSLocalizedLabels = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      routes: <String, WidgetBuilder>{
        '/contactsList': (BuildContext context) => ContactListPage(),
      },
      title: 'PhoneBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        //Jo default themedata.dark() hai use hum changes kr rhe hai ...thus, copyWith()
        primaryColor: Color(0xFF0A0E21),
        //0xFF is for full opacity of that particular hex code #0A0E21
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return LoginPage();
                } else {
                  return ContactsPage();
                }
              }
              return Scaffold(
                body: Center(
                  child: Text('Checking Authentication...'),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Text('Connecting to the app...'),
          ),
        );
      },
    );
  }
}
