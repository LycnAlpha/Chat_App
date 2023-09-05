import 'package:chat_bot/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: 500,
                width: 500,
                child: Image.asset('assest/logo.jpg'),
              ),
              Text(
                "Nezuko-Chan",
                style: GoogleFonts.shadowsIntoLight(fontSize: 70),
              ),
              Text(
                "Let's Chat",
                style: GoogleFonts.shadowsIntoLight(fontSize: 30),
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
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage())),
                  child: Text("Get Started",
                      style: GoogleFonts.shadowsIntoLight(fontSize: 40))),
            ],
          ),
        )
      ],
    );
  }
}
