import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/auth/domain/usecases/phone_authentication.dart';
import 'package:mustye/src/auth/domain/usecases/update_profile.dart';
import 'package:mustye/src/auth/domain/usecases/verify_otp.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required PhoneAuthentication phoneAuthentication,
    required VerifyOTP verifyOtp,
    required UpdateUser updateUser,
  }) : _phoneAuthentication = phoneAuthentication,
       _verifyOtp = verifyOtp,
       _updateUser = updateUser,
       super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<PhoneAuthenticationEvent>(_phoneAuthenticationHandler);
    on<VerifyOTPEvent>(_verifyOTPHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  final PhoneAuthentication _phoneAuthentication;
  final VerifyOTP _verifyOtp;
  final UpdateUser _updateUser;

  Future<void> _phoneAuthenticationHandler(
    PhoneAuthenticationEvent event,
    Emitter<AuthState> emit,
  ) async {
    // final result = await _phoneAuthentication(event.phone);

    // result.fold(
    //   (failure) => emit(AuthError(failure.errorMessage)),
    //   (code) => emit(CheckVerificationCode(code)),
    // );

    await Future.delayed(const Duration(seconds: 3));
    emit(const OTPSent('342569'));
  }

  Future<void> _verifyOTPHandler(
    VerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _verifyOtp(event.otp);

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(PhoneAuthSuccess()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(action: event.action, userData: event.userData),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
