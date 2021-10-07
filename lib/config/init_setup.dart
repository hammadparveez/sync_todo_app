import 'package:notifications/domain/factory/authentication_factory.dart';
import 'package:notifications/domain/factory/todo_item_factory.dart';
import 'package:notifications/export.dart';

Future<void> setupInit() async {
  //Hive InitFlutter already called  ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();

  await Hive.openBox(LOGIN_BOX);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  //Register Service Locator
  GetIt.instance
      .registerLazySingleton<NetworkService>(() => NetworkServiceImpl());

  ///Register Authentication Factory
  GetIt.instance.registerLazySingleton<AuthenticationFactory>(
      () => UserAccountAuthFactory());
  GetIt.instance
      .registerLazySingleton<ToDoItemFactory>(() => TodoItemFactoryImpl());
}
