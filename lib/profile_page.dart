import 'package:cab/bloc/auth_bloc.dart';
import 'package:cab/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedOption;
  final TextEditingController _genderController = TextEditingController();
  void _handleRadioValueChanged(String? value) {
    setState(() {
      _selectedOption = value;
      _genderController.text = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Text(
                    "Profile Details",
                    style: GoogleFonts.adamina(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name",
                      style: GoogleFonts.adamina(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.adamina(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: "Enter Name",
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.adamina(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.adamina(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: "Enter Email Id",
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Gender",
                      style: GoogleFonts.adamina(fontSize: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Male',
                              activeColor: Colors.black,
                              focusColor: Colors.black,
                              groupValue: _selectedOption,
                              onChanged: _handleRadioValueChanged,
                            ),
                            Text(
                              'Male',
                              style: GoogleFonts.adamina(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Female',
                              activeColor: Colors.black,
                              focusColor: Colors.black,
                              groupValue: _selectedOption,
                              onChanged: _handleRadioValueChanged,
                            ),
                            Text(
                              'Female',
                              style: GoogleFonts.adamina(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Others',
                              activeColor: Colors.black,
                              focusColor: Colors.black,
                              groupValue: _selectedOption,
                              onChanged: _handleRadioValueChanged,
                            ),
                            Text(
                              'Others',
                              style: GoogleFonts.adamina(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                              AuthProfileEvent(
                                  customerName: _nameController.text,
                                  customerEmail: _emailController.text,
                                  customerGender: _genderController.text));
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
                            "Save",
                            style: GoogleFonts.adamina(
                                fontSize: 20, color: Colors.white),
                          ),
                        )),
                  ),
                ])),
          ),
        ),
      ),
    );
  }
}
