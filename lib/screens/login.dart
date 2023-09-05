import 'package:chat_bot/screens/profile.dart';
import 'package:chat_bot/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";

  showAlertDialog(BuildContext context, String content) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login"),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: 200,
                width: 500,
                child: Image.asset('assest/logo.jpg'),
              ),
              Text(
                "First time?",
                style: GoogleFonts.shadowsIntoLight(fontSize: 50),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Signup())),
                  style: TextButton.styleFrom(primary: Colors.pink),
                  child: Text("Signup",
                      style: GoogleFonts.shadowsIntoLight(fontSize: 30))),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                  ),
                  onPressed: () async {
                    try {
                      _auth.signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      _auth.authStateChanges().listen((User? user) {
                        if (user != null) {
                          //print(user.uid);
                          uid = user.uid;
                          showAlertDialog(context, "Success");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserProfile(
                                    uid: uid,
                                  )));
                        }
                      });
                    } catch (e) {
                      showAlertDialog(context, e.toString());

                      print(e);
                    }
                  },
                  child: Text("Login",
                      style: GoogleFonts.shadowsIntoLight(fontSize: 40))),
            ],
          ),
        )
      ],
    );
  }
}
