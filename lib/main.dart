import 'package:notifications/export.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  await setupInit();
  runApp(
    ProviderScope(
        child: DevicePreview(
            enabled: true,
            builder: (context) {
              return App();
            })),
  );
}
