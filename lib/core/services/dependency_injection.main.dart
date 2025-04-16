part of 'dependency_injection.dart';

final sl = GetIt.instance;

/// Injectiing Dependencies 

Future<void> init() async {
  await _initAuth();
  await _initContacts();
  await _initChats();
  await _initMessages();
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

/// Feature --> Contacts

Future<void> _initContacts() async{

  sl
    ..registerFactory(
      () => ContactProvider(
        addContact: sl(),
      ),
    )
    ..registerLazySingleton(() => GetContacts(sl()))
    ..registerLazySingleton(() => AddContact(sl()))
    ..registerLazySingleton<ContactRepo>(() => ContactRepoImpl(sl()))
    ..registerLazySingleton<ContactRemoteDataSrc>(
      () => ContactRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
      ),
    );
}


/// Feature --> Chats

Future<void> _initChats() async{

  sl
    ..registerFactory(() => ChatCubit(getChats: sl()))
    ..registerLazySingleton(() => GetChats(sl()))
    ..registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl()))
    ..registerLazySingleton<ChatRemoteDataSrc>(
      () => ChatRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
      ),
    );
}


/// Feature --> Messages

Future<void> _initMessages() async{

  sl
    ..registerFactory(() => MessageProvider(sendMessage: sl()))
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton<MessageRepo>(() => MessageRepoImpl(sl()))
    ..registerLazySingleton<MessageRemoteDataSrc>(
      () => MessageRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
      ),
    );
}
