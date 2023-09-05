import 'package:chat_bot/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_bot/models/userModel.dart' as model;
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<UserProfile> createState() => _UserProfileState(uid);
}

class _UserProfileState extends State<UserProfile> {
  final db = FirebaseFirestore.instance;
  String? bio = "";
  String? url = "";
  String? uName = "";
  String? email = "";
  String uid = "";
  _UserProfileState(this.uid);

  void getData() async {
    print(uid + "Hello");
    final ref = db.collection("Users").doc(uid).withConverter(
          fromFirestore: model.userModel.fromFirestore,
          toFirestore: (model.userModel user, _) => user.toFirestore(),
        );
    final docSnap = await ref.get();
    final userPofileData = docSnap.data();
    if (userPofileData != null) {
      bio = userPofileData.bio;
      if (userPofileData.photoUrl == "") {
        url =
            "https://firebasestorage.googleapis.com/v0/b/chat-buddy-8eb17.appspot.com/o/profilePics%2FuserIcon.png?alt=media&token=b8609ec2-57ad-4b74-a160-bde410f674ba";
      } else {
        url = userPofileData.photoUrl;
      }
      uName = userPofileData.userName;
      email = userPofileData.email;
      print(userPofileData.userName);
    } else {
      print("No such document.");
    }
    setState(() {});
  }

  @override
  void initState() {
    setState(() {});
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 232, 176, 176),
          body: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.all(25.0),
                width: 150,
                height: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(image: NetworkImage(url!))),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(uName!,
                    style: GoogleFonts.shadowsIntoLight(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(email!,
                    style: GoogleFonts.shadowsIntoLight(fontSize: 25)),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 100,
                width: 380,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                alignment: Alignment.centerLeft,
                child: Text(bio!,
                    style: GoogleFonts.shadowsIntoLight(fontSize: 25)),
              ),
              const SizedBox(
                height: 50,
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
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Text("Logout",
                      style: GoogleFonts.shadowsIntoLight(fontSize: 40))),
            ],
          ),
        )
      ],
    );
  }
}
