import 'package:notifications/domain/factory/firebase_factory.dart';
import 'package:notifications/export.dart';

Future<void> setupInit() async {
  //Hive InitFlutter already called  ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.clearPersistence();
  await Hive.openBox(LOGIN_BOX);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  //Register Service Locator
  GetIt.instance.registerFactory<NetworkService>(() => NetworkServiceImpl());
  ///Register Authentication Factory
  GetIt.instance
      .registerFactory<AuthenticationFactory>(() =>UserAccountAuthFactory());
      
}
