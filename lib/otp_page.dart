// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:cab/bloc/auth_bloc.dart';
import 'package:cab/login.dart';
import 'package:cab/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpPage extends StatefulWidget {
  final String? phoneNumber;
  const OtpPage({
    super.key,
    this.phoneNumber,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool show = true;
  void _callback() {
    setState(() {
      show = false;
    });
  }

  void getOTP() async {
    final uri = Uri.parse("http://localhost:8080/otp");
    await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            Login(phoneNumber: widget.phoneNumber.toString()).tojson()));
  }

  @override
  Widget build(BuildContext context) {
    String? otp;
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Log in using the OTP sent to +${widget.phoneNumber}",
                    style:
                        GoogleFonts.adamina(fontSize: 20, color: Colors.black),
                  ),
                  OtpTextField(
                    numberOfFields: 4,
                    keyboardType: TextInputType.number,
                    onSubmit: (value) {
                      otp = value;
                    },
                  ),
                  show
                      ? TimerWidget(
                          callback: _callback,
                        )
                      : Column(
                          children: [
                            Text(
                              "Didn't get the OTP?",
                              style: GoogleFonts.adamina(
                                  fontSize: 18, color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                getOTP();
                              },
                              child: Text(
                                "Resend Otp",
                                style: GoogleFonts.adamina(
                                    fontSize: 18, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                        onPressed: () async {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthOtpEvent(otp: otp!));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SearchPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "Verify",
                            style: GoogleFonts.adamina(
                                fontSize: 20, color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}

class TimerWidget extends StatefulWidget {
  final VoidCallback callback;
  const TimerWidget({super.key, required this.callback});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _seconds = 15;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  String get _format {
    int min = _seconds ~/ 60;
    int sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_seconds > 0) {
          setState(() {
            _seconds--;
          });
        } else {
          _timer.cancel;
          setState(() {
            widget.callback();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "You will get OTP by SMS in $_format",
      style: const TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
    );
  }
}
