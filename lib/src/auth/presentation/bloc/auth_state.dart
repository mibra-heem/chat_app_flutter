part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class PhoneAuthSuccess extends AuthState {}

class OTPSent extends AuthState {
  const OTPSent(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}

class CheckVerificationCode extends AuthState {
  const CheckVerificationCode(this.otp);
  final String otp;

  @override
  List<Object> get props => [otp];
}

class SignedIn extends AuthState {
  const SignedIn(this.user);

  final LocalUser user;

  @override
  List<Object> get props => [user];
}

class SignedUp extends AuthState {
  const SignedUp();
}

class ForgotPasswordSent extends AuthState {
  const ForgotPasswordSent();
}

class UserUpdated extends AuthState {
  const UserUpdated();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
