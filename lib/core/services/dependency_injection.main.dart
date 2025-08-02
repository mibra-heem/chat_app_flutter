part of 'dependency_injection.dart';

final sl = GetIt.instance;

/// Injectiing Dependencies

Future<void> init() async {
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initApiClient();
  await _initAuth();
  await _initTheme();
  await _initContacts();
  await _initChats();
  await _initMessages();
  await _initFcmToken();
  await _initUser();
  await NotificationService.requestPermission(FirebaseMessaging.instance);
  await NotificationService.initFirebaseNotificationListeners();
  await NotificationService.setFcmToken();
}

// Setup ApiClient
Future<void> _initApiClient() async {
  sl.registerLazySingleton(() => ApiService(baseUrl: ApiConfig.baseUrl));
}

// Initialize the LocalUserModel from cachedUserData
Future<void> _initUser() async {
  if (sl<FirebaseAuth>().currentUser != null) {
    await sl<UserProvider>().getUserCachedData();
  }
}

// Initialize fcmToken in service locator for global access
Future<void> _initFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  sl.registerLazySingleton<String>(
    () => fcmToken!,
    instanceName: ApiConfig.fcmToken,
  );
}

/// Feature --> Auth
Future<void> _initAuth() async {
  await Hive.initFlutter();
  final userBox = await Hive.openBox<dynamic>(StorageConfig.userBox);

  sl
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        phoneAuthentication: sl(),
        verifyOtp: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton<UserProvider>(
      () => UserProvider(getUserCachedData: sl(), cacheUserData: sl()),
    )
    ..registerLazySingleton(() => PhoneAuthentication(sl()))
    ..registerLazySingleton(() => VerifyOTP(sl()))
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
      ),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSrcImpl(
        userBox: sl<Box<dynamic>>(instanceName: StorageConfig.userBox),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(
      () => GoogleSignIn(
        scopes: AuthConfig.scopes,
        clientId: AuthConfig.googleWebOAuthClientId,
      ),
    )
    ..registerLazySingleton(() => userBox, instanceName: StorageConfig.userBox);
}

/// Feature --> Theme
Future<void> _initTheme() async {
  final themeBox = await Hive.openBox<dynamic>(StorageConfig.themeBox);

  sl
    ..registerLazySingleton(
      () => ThemeProvider(cacheThemeMode: sl(), loadThemeMode: sl()),
    )
    ..registerLazySingleton(() => CacheThemeMode(sl()))
    ..registerLazySingleton(() => LoadThemeMode(sl()))
    ..registerLazySingleton<ThemeRepo>(() => ThemeRepoImpl(sl()))
    ..registerLazySingleton<ThemeLocalDataSrc>(
      () => ThemeLocalDataSrcImpl(
        themeBox: sl<Box<dynamic>>(instanceName: StorageConfig.themeBox),
      ),
    )
    ..registerLazySingleton(
      () => themeBox,
      instanceName: StorageConfig.themeBox,
    );
}

/// Feature --> Contacts
Future<void> _initContacts() async {
  sl
    ..registerLazySingleton(
      () => ContactProvider(addContact: sl(), getContacts: sl()),
    )
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
  final chatBox = await Hive.openBox<dynamic>(StorageConfig.chatBox);

  sl
    ..registerLazySingleton<MessageProvider>(
      () => MessageProvider(
        sendMessage: sl(),
        activateChat: sl(),
        deleteMessages: sl(),
      ),
    )
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton(() => ActivateChat(sl()))
    ..registerLazySingleton(() => DeleteMessages(sl()))
    ..registerLazySingleton<MessageRepo>(() => MessageRepoImpl(sl()))
    ..registerLazySingleton<MessageRemoteDataSrc>(
      () => MessageRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
        chatBox: sl<Box<dynamic>>(instanceName: StorageConfig.chatBox),
        apiClient: sl(),
      ),
    )
    ..registerLazySingleton(() => chatBox, instanceName: StorageConfig.chatBox);
}
