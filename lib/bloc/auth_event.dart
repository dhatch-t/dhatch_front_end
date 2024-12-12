part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  final String customerPhoneNumber;
  AuthLoginEvent({required this.customerPhoneNumber});
}

final class AuthOtpEvent extends AuthEvent {
  final String customerOtp;
  AuthOtpEvent({required this.customerOtp});
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
