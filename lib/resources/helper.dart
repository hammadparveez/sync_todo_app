import 'package:notifications/export.dart';

Future<bool> get hasConnection async {
  final isConnected = await getIt.get<NetworkService>().hasConnection();
  return isConnected ? true : false;
}
