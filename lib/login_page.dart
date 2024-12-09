import 'package:cab/bloc/auth_bloc.dart';
import 'package:cab/otp_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = TextEditingController();
  String _countryCode = "91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Enter Phone number for verification",
                  style: GoogleFonts.adamina(fontSize: 25),
                ),
                Text(
                  "This number will be used for all ride-related communication. You shall receive an SMS with code for verification",
                  style: GoogleFonts.adamina(fontSize: 15),
                ),
                IntlPhoneField(
                  controller: _controller,
                  initialCountryCode: 'IN',
                  onCountryChanged: (value) {
                    _countryCode = value.dialCode;
                  },
                  dropdownTextStyle: const TextStyle(fontSize: 18),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Your number",
                    hintStyle: TextStyle(fontSize: 20),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 113, 9, 126),
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 113, 9, 126),
                      ),
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 113, 9, 126),
                    )),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 1,
                      color: Colors.black,
                    )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(AuthLoginEvent(
                            customerPhoneNumber:
                                _countryCode + _controller.text));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OtpPage(
                                  customerPhoneNumber:
                                      _countryCode + _controller.text,
                                )));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Next",
                          style: GoogleFonts.adamina(
                              fontSize: 20, color: Colors.white),
                        ),
                      )),
                ),
              ],
            )),
      )),
    );
  }
}
