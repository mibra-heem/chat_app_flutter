part of 'dependency_injection.dart';

final sl = GetIt.instance;

/// Injectiing Dependencies 

Future<void> init() async {
  await _initAuth();
  await _initContacts();
}

/// Feature --> Auth

Future<void> _initAuth() async{

  sl
    ..registerFactory(
      () => AuthBloc(
        googleSignIn: sl(),
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(), 
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => GoogleLoginIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSrcImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
        googleSignIn: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => GoogleSignIn(
        scopes: ['openid', 'email', 'profile'],
      ),
    );
}

/// Feature --> Auth

Future<void> _initContacts() async{

  sl
    ..registerFactory(
      () => ContactCubit(
        getContacts: sl(),
      ),
    )
    ..registerLazySingleton(() => GetContacts(sl()))
    ..registerLazySingleton<ContactRepo>(() => ContactRepoImpl(sl()))
    ..registerLazySingleton<ContactRemoteDataSrc>(
      () => ContactRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
      ),
    );
}
