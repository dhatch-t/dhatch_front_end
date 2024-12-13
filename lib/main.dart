import 'package:dhatch_front_end/bloc/auth_bloc.dart';
import 'package:dhatch_front_end/pages/home_page.dart';
import 'package:dhatch_front_end/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//import 'package:device_preview/device_preview.dart';

Future<void> storeDeviceId() async {
  var prefs = await SharedPreferences.getInstance();
  var uuid = const Uuid();
  if (!prefs.containsKey('device_id')) {
    String deviceId = uuid.v4();
    await prefs.setString('device_id', deviceId);
  }
}

Future<bool> getStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? phone = prefs.getString("customerPhoneNumber");
  String? name = prefs.getString("customerName");
  // String? gender = prefs.getString("customerGender");
  // String? email = prefs.getString("customerEmail");

  return name != null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await storeDeviceId();
  //runApp(DevicePreview(builder: (context) => const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: getStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            } else {
              bool status = snapshot.data ?? false;
              return status ? const SearchPage() : const HomePage();
              //return const SearchDestinationPage();
            }
          },
        ),
      ),
    );
  }
}
