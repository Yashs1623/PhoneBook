import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'contacts_page.dart';

const loginAndCreateNewAcc = TextStyle(
  fontSize: 18.0,
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

  void showToast(String string) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFF0A0E21),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        String s = 'The account already exists for that email.';
        showToast(s);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        String s1 = 'No user found for that email.';
        showToast(s1);
      } else if (e.code == 'wrong-password') {
        String s2 = 'Wrong password provided for that user.';
        showToast(s2);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'PhoneBook',
            style: textStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  _email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Your Email.. ',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (value) {
                  _password = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Your Password.. ',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: _login,
                    child: Text(
                      'Login',
                      style: loginAndCreateNewAcc,
                    ),
                  ),
                  MaterialButton(
                    onPressed: _createUser,
                    child: Text(
                      'Create New Account',
                      style: loginAndCreateNewAcc,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
