import 'package:dhatch_front_end/bloc/auth_bloc.dart';
import 'package:dhatch_front_end/pages/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
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
                const Text(
                  "Enter Phone number for verification",
                  style: TextStyle(fontFamily: 'Adamina', fontSize: 25),
                ),
                const Text(
                  "This number will be used for all ride-related communication. You shall receive an SMS with code for verification",
                  style: TextStyle(fontFamily: 'Adamina', fontSize: 15),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 10) {
                        return "Enter correct phone number";
                      }
                      return null;
                    },
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(AuthLoginEvent(
                              customerPhoneNumber: _controller.text));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OtpPage(
                                    customerPhoneNumber: _controller.text,
                                  )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontFamily: 'Adamina',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      )),
                ),
              ],
            )),
      )),
    );
  }
}
