import 'package:notifications/export.dart';

Future<void> setupInit() async {
  //Hive InitFlutter already defined ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.clearPersistence();
  await Hive.openBox(LOGIN_BOX);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  //Register Service Locator
  GetIt.instance.registerFactory<NetworkService>(() => NetworkServiceImpl());
}

void main() async {
  await setupInit();
  runApp(ProviderScope(child: App()));
}
