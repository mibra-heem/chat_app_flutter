part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class PhoneAuthenticationEvent extends AuthEvent{

  const PhoneAuthenticationEvent(this.phone);

  final String phone;

  @override
  List<String> get props => [phone];

}

class VerifyOTPEvent extends AuthEvent{

  const VerifyOTPEvent(this.otp);

  final String otp;

  @override
  List<String> get props => [otp];

}

class UpdateUserEvent extends AuthEvent{

  const UpdateUserEvent(
    {
      required this.action, 
      required this.userData,
    }) : assert(
      userData is String || userData is File,
      'userData can only be a String or File',
    );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];

}
