import 'dart:convert';

import 'package:dhatch_front_end/model/customer.dart';
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

      if (event.customerPhoneNumber.isNotEmpty) {
        final uri = Uri.parse(
            'http://192.168.1.7:8080/Customer/customerLogin/${event.customerPhoneNumber}/$uuid');
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

      int otp = int.parse(event.customerOtp);
      if (event.customerOtp.isNotEmpty) {
        final uri = Uri.parse('http://192.168.1.7:8080/Customer/sendOtp');
        final response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(
              {"customerPhoneNumber": customerPhoneNumber, "customerOtp": otp}),
        );
        if (response.body == "Existing") {
          emit(AuthLoading());
          final uri = Uri.parse(
              'http://192.168.1.7:8080/Customer/getCustomerProfile/$customerPhoneNumber');
          final response = await http.get(
            uri,
            headers: {"Content-Type": "application/json"},
          );
          Customer customer = Customer.fromjson(json.decode(response.body));
          prefs.setString("customerName", customer.customerName!);
          prefs.setString("customerGender", customer.customerGender!);
          prefs.setString("customerEmail", customer.customerEmail!);
        }
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

      if (event.customerName.isEmpty) {
        return emit(AuthFailure(error: "Please enter your name"));
      }
      if (!event.customerEmail.contains("@gmail.com")) {
        return emit(AuthFailure(error: "Please enter valid email ID"));
      }
      if (event.customerGender.isEmpty) {
        return emit(AuthFailure(error: "Please select the gender"));
      }

      prefs.setString("customerName", event.customerName);
      prefs.setString("customerGender", event.customerGender);
      prefs.setString("customerEmail", event.customerEmail);
      final uri =
          Uri.parse('http://192.168.1.7:8080/Customer/updateCustomerProfile');
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
