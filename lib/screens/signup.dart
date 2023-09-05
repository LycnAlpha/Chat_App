import 'package:chat_bot/screens/login.dart';
import 'package:chat_bot/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bot/models/userModel.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  File? _image;
  final picker = ImagePicker();
  int count = 0;
  String uid = "";

  void signUp() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      final user = userCredential.user;
      uid = user!.uid.toString();
      showAlertDialog(context, "Success");
    } catch (e) {
      showAlertDialog(context, e.toString());
      print(e);
    }

    model.userModel _user = model.userModel(
        userName: userName.text,
        bio: bio.text,
        email: email.text,
        photoUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-buddy-8eb17.appspot.com/o/profilePics%2FHD-wallpaper-shinobu-kocho-anime-girl-demon-slayer-shinobu-kocho.jpg?alt=media&token=9d70eda8-6ffb-4472-853e-c303e145811b",
        userID: uid);

    final docRef = db
        .collection("Users")
        .withConverter(
          fromFirestore: model.userModel.fromFirestore,
          toFirestore: (model.userModel user, options) => user.toFirestore(),
        )
        .doc(uid);
    await docRef.set(_user);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageFile = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

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
      title: Text("Signup"),
      content: Text(content),
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
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: _image != null
                      ? Image.file(_image!)
                      : Image.asset('assest/userIcon.png')),
              Container(
                  width: 100,
                  child: IconButton(
                      onPressed: () {
                        takePhoto(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.add_a_photo))),
              Container(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: userName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: bio,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bio',
                    ),
                  )),
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
                  onPressed: () {
                    signUp();
                  },
                  child: Text("Signup",
                      style: GoogleFonts.shadowsIntoLight(fontSize: 40))),
            ],
          ),
        )
      ],
    );
  }
}
