// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dhatch_front_end/bloc/auth_bloc.dart';
import 'package:dhatch_front_end/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String? customerPhoneNumber;
  const OtpPage({
    super.key,
    this.customerPhoneNumber,
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

  @override
  Widget build(BuildContext context) {
    String? customerOtp;

    authLoginEvent(String? customerPhoneNumber) {
      BlocProvider.of<AuthBloc>(context)
          .add(AuthLoginEvent(customerPhoneNumber: customerPhoneNumber!));
    }

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
                    "Log in using the OTP sent to +91${widget.customerPhoneNumber}",
                    style: const TextStyle(
                        fontFamily: 'Adamina',
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  OtpTextField(
                    numberOfFields: 4,
                    keyboardType: TextInputType.number,
                    onSubmit: (value) {
                      customerOtp = value;
                    },
                  ),
                  show
                      ? TimerWidget(
                          callback: _callback,
                        )
                      : Column(
                          children: [
                            const Text(
                              "Didn't get the OTP?",
                              style: TextStyle(
                                  fontFamily: 'Adamina',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String? customerPhoneNumber =
                                    prefs.getString("customerPhoneNumber");
                                authLoginEvent(customerPhoneNumber);
                              },
                              child: const Text(
                                "Resend Otp",
                                style: TextStyle(
                                    fontFamily: 'Adamina',
                                    fontSize: 18,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                        onPressed: () async {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthOtpEvent(customerOtp: customerOtp!));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "Verify",
                            style: TextStyle(
                                fontFamily: 'Adamina',
                                fontSize: 20,
                                color: Colors.white),
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
