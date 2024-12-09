import 'package:cab/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "DHATCH",
            style: GoogleFonts.adamina(fontSize: 50),
          ),
          Image.asset("assets/images/cab.jpg"),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Explore your ways to travel with Dhatch",
              style: GoogleFonts.adamina(
                  fontSize: 25, fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "Continue with Phone Number",
                  style: GoogleFonts.adamina(fontSize: 20, color: Colors.white),
                ),
              )),
          const Text(
            "Terms & Conditions",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          )
        ],
      )),
    );
  }
}
