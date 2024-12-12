import 'package:dhatch_front_end/pages/login_page.dart';
import 'package:flutter/material.dart';

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
          const Text(
            "DHATCH",
            style: TextStyle(
              fontFamily: 'Adamina',
              fontSize: 50,
            ),
          ),
          Image.asset("assets/images/cab.jpg"),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Explore your ways to travel with Dhatch",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Adamina',
              ),
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
              child: const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "Continue with Phone Number",
                  style: TextStyle(
                      fontFamily: 'Adamina', fontSize: 20, color: Colors.white),
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
