
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mustye/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:mustye/src/datasources/auth_remote_data_src.dart';
import 'package:mustye/src/repositories/auth_repo.dart';
import 'package:mustye/src/usecases/auth/forgot_password.dart';
import 'package:mustye/src/usecases/auth/sign_in.dart';
import 'package:mustye/src/usecases/auth/sign_up.dart';
import 'package:mustye/src/usecases/auth/update_profile.dart';

part 'dependency_injection.main.dart';
