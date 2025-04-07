part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class GoogleSignInEvent extends AuthEvent{

  const GoogleSignInEvent();

  @override
  List<String> get props => [];

}

class SignInEvent extends AuthEvent{

  SignInEvent({required this.email, required this.password}){
    if(kDebugMode) print('SignIn Event Triggered...');
  }

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];

}

class SignUpEvent extends AuthEvent{

  const SignUpEvent(
    {
      required this.name,
      required this.email, 
      required this.password,
    });

  final String name;
  final String email;
  final String password;

  @override
  List<String> get props => [name, email, password];

}

class ForgotPasswordEvent extends AuthEvent{

  const ForgotPasswordEvent({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
  
}

class UpdateUserEvent extends AuthEvent{

  UpdateUserEvent(
    {
      required this.action, 
      required this.userData,
    }) : assert(
      userData is String || userData is File,
      'userData can only be a String or File, but was ${userData.runtimeType}.',
    );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];

}
