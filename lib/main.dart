import 'package:cab/bloc/auth_bloc.dart';
import 'package:cab/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> storeDeviceId() async {
  var prefs = await SharedPreferences.getInstance();
  var uuid = const Uuid();
  if (!prefs.containsKey('device_id')) {
    String deviceId = uuid.v4();
    await prefs.setString('device_id', deviceId);
  } else {
    prefs.getString('device_id');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  storeDeviceId();
  //runApp(DevicePreview(builder: (context) => const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
