import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/auth/domain/usecases/forgot_password.dart';
import 'package:mustye/src/auth/domain/usecases/google_sign_in.dart';
import 'package:mustye/src/auth/domain/usecases/sign_in.dart';
import 'package:mustye/src/auth/domain/usecases/sign_up.dart';
import 'package:mustye/src/auth/domain/usecases/update_profile.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GoogleLoginIn googleSignIn,
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
  })  : _googleSignIn = googleSignIn,
        _signUp = signUp,
        _signIn = signIn,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<GoogleSignInEvent>(_googleSignInHandler);
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  final GoogleLoginIn _googleSignIn;
  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;

  Future<void> _googleSignInHandler(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _googleSignIn();

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
