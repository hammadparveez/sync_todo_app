import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notifications/domain/services/network_service/network_service.dart';
import 'package:notifications/ui/app/app.dart';

final getIt = GetIt.I;

Future<void> setupInit() async {
  //Hive InitFlutter Already defined ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await Hive.openBox('loginBox');

  //Register Service Locator
  GetIt.instance.registerFactory<NetworkService>(() => NetworkServiceImpl());
}

void main() async {
  await setupInit();
  runApp(ProviderScope(child: App()));
}
