
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';

class DefaultElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const DefaultElevatedButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          textStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          fixedSize: MaterialStateProperty.all(Size.fromWidth(.7.sw)),
          backgroundColor: MaterialStateProperty.all(Styles.defaultColor),
        ),
        child: Text(title));
  }
}

