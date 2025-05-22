part of 'dependency_injection.dart';

final sl = GetIt.instance;

/// Injectiing Dependencies

Future<void> init() async {
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initAuth();
  await _initSettings();
  await _initContacts();
  await _initChats();
  await _initMessages();
}

/// Feature --> Auth

Future<void> _initAuth() async {
  await Hive.initFlutter();

  final userBox = await Hive.openBox<dynamic>(StorageConstant.userBox);

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
    ..registerFactory(
      () => UserProvider(getUserCachedData: sl(), cacheUserData: sl()),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => GoogleLoginIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => CacheUserData(sl()))
    ..registerLazySingleton(() => GetUserCachedData(sl()))
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSrcImpl(
        authClient: sl(),
        firestore: sl(),
        dbClient: sl(),
        googleSignIn: sl(),
      ),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSrcImpl(
        userBox: sl<Box<dynamic>>(instanceName: StorageConstant.userBox),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(
      () => GoogleSignIn(
        scopes: AuthConstant.scopes,
        clientId: AuthConstant.clientId,
      ),
    )
    ..registerLazySingleton(
      () => userBox,
      instanceName: StorageConstant.userBox,
    );
}

/// Feature --> Settings

Future<void> _initSettings() async {
  final settingBox = await Hive.openBox<dynamic>(StorageConstant.settingBox);

  sl
    ..registerFactory(
      () => SettingProvider(cacheDarkMode: sl(), checkIfDarkModeOn: sl()),
    )
    ..registerLazySingleton(() => CacheDarkMode(sl()))
    ..registerLazySingleton(() => CheckIfDarkModeOn(sl()))
    ..registerLazySingleton<SettingRepo>(() => SettingRepoImpl(sl()))
    ..registerLazySingleton<SettingLocalDataSrc>(
      () => SettingLocalDataSrcImpl(
        settingBox: sl<Box<dynamic>>(instanceName: StorageConstant.settingBox),
      ),
    )
    ..registerLazySingleton(
      () => settingBox,
      instanceName: StorageConstant.settingBox,
    );
}

/// Feature --> Contacts

Future<void> _initContacts() async {
  sl
    ..registerFactory(() => ContactProvider(addContact: sl()))
    ..registerLazySingleton(() => GetContacts(sl()))
    ..registerLazySingleton(() => AddContact(sl()))
    ..registerLazySingleton<ContactRepo>(() => ContactRepoImpl(sl()))
    ..registerLazySingleton<ContactRemoteDataSrc>(
      () => ContactRemoteDataSrcImpl(auth: sl(), firestore: sl()),
    );
}

/// Feature --> Chats

Future<void> _initChats() async {
  sl
    ..registerFactory(() => ChatProvider(messageSeen: sl(), deleteChat: sl()))
    ..registerLazySingleton(() => MessageSeen(sl()))
    ..registerLazySingleton(() => DeleteChat(sl()))
    ..registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl()))
    ..registerLazySingleton<ChatRemoteDataSrc>(
      () => ChatRemoteDataSrcImpl(auth: sl(), firestore: sl()),
    );
}

/// Feature --> Messages

Future<void> _initMessages() async {
  final chatBox = await Hive.openBox<dynamic>(StorageConstant.chatBox);

  sl
    ..registerFactory(
      () => MessageProvider(sendMessage: sl(), activateChat: sl()),
    )
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton(() => ActivateChat(sl()))
    ..registerLazySingleton<MessageRepo>(() => MessageRepoImpl(sl()))
    ..registerLazySingleton<MessageRemoteDataSrc>(
      () => MessageRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
        chatBox: sl<Box<dynamic>>(instanceName: StorageConstant.chatBox),
      ),
    )
    ..registerLazySingleton(
      () => chatBox,
      instanceName: StorageConstant.chatBox,
    );
}
