part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  final String phoneNumber;
  AuthLoginEvent({required this.phoneNumber});
}

final class AuthOtpEvent extends AuthEvent {
  final String otp;
  AuthOtpEvent({required this.otp});
}

final class AuthProfileEvent extends AuthEvent {
  final String customerName;
  final String customerEmail;
  final String customerGender;

  AuthProfileEvent(
      {required this.customerName,
      required this.customerEmail,
      required this.customerGender});
}
