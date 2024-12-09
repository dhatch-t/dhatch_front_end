import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("customerPhoneNumber", event.customerPhoneNumber);
      String? uuid = prefs.getString('device_id');
      emit(AuthLoading());
      if (event.customerPhoneNumber.isNotEmpty) {
        final uri = Uri.parse(
            'http://localhost:8081/Customer/customerLogin/${event.customerPhoneNumber}/$uuid');
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
      String? customerPhoneNumber = prefs.getString("customerPhoneNumber");
      emit(AuthLoading());
      if (event.customerOtp.isNotEmpty) {
        final uri = Uri.parse('http://localhost:8081/Customer/sendOtp');
        final response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "customerPhoneNumber": customerPhoneNumber,
            "customerOtp": event.customerOtp
          }),
        );
        print(response.body);
        return emit(AuthSuccess(status: response.body));
      } else {
        return emit(
          AuthFailure(error: 'Password error'),
        );
      }
    });

    on<AuthProfileEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? customerPhoneNumber = prefs.getString("customerPhoneNumber");

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
          "customerPhoneNumber": customerPhoneNumber,
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
