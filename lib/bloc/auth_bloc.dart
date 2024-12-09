import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("phone", event.phoneNumber);
      String? uuid = prefs.getString('device_id');
      emit(AuthLoading());
      if (event.phoneNumber.isNotEmpty) {
        final uri = Uri.parse(
            'http://localhost:8081/Customer/customerLogin/${event.phoneNumber}/$uuid');
        await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
        );
        emit(AuthSuccess(status: "Done"));
        return;
      } else {
        return emit(
          AuthFailure(error: 'Password error'),
        );
      }
    });

    on<AuthOtpEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? phoneNumber = prefs.getString("phone");
      emit(AuthLoading());
      if (event.otp.isNotEmpty) {
        final uri = Uri.parse('http://localhost:8081/Customer/sendOtp');
        final response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(
              {"customerPhoneNumber": phoneNumber, "customerOtp": event.otp}),
        );

        return emit(AuthSuccess(status: response.body));
      } else {
        return emit(
          AuthFailure(error: 'Password error'),
        );
      }
    });

    on<AuthProfileEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? phoneNumber = prefs.getString("phone");

      emit(AuthLoading());

      if (event.customerName.isEmpty) {
        return emit(AuthFailure(error: "Please enter your name"));
      }
      if (!event.customerEmail.contains("@gmail.com")) {
        return emit(AuthFailure(error: "Please enter valid email ID"));
      }
      if (event.customerGender.isEmpty) {
        return emit(AuthFailure(error: "Please select the gender"));
      }

      final uri = Uri.parse('http://localhost:8081/Customer/saveProfile');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "customerPhoneNumber": phoneNumber,
          "customerName": event.customerName,
          "customerEmail": event.customerEmail,
          "customerGender": event.customerGender
        }),
      );
      if (response.statusCode == 200) {
        return emit(AuthSuccess(status: "profile saved"));
      } else {
        return emit(AuthFailure(error: response.body));
      }
    });
  }
}
