import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notifications/ui/app/app.dart';

Future<void> setupInit() async {
  //Hive InitFlutter Already defined ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await Hive.openBox('loginBox');
}

void main() async {
  await setupInit();
  runApp(ProviderScope(child: App()));
}
