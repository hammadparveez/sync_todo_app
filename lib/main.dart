import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notifications/domain/services/network_service/network_service.dart';
import 'package:notifications/export.dart';

final getIt = GetIt.I;
final fireStoreOption = GetOptions(source: Source.server);

Future<void> setupInit() async {
  //Hive InitFlutter Already defined ensureInitialized();
  await Hive.initFlutter();

  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  await FirebaseFirestore.instance.clearPersistence();
  await Hive.openBox('loginBox');

  //Register Service Locator
  GetIt.instance.registerFactory<NetworkService>(() => NetworkServiceImpl());
}

void main() async {
  await setupInit();
  runApp(ProviderScope(child: App()));
}
