import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomTextButton(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(title));
  }
}
