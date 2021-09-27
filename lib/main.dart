import 'package:notifications/export.dart';

void main() async {
  await setupInit();
  runApp( ProviderScope(child: App()),);
}
