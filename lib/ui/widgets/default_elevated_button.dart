import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';

class DefaultElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  DefaultElevatedButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //log("Button Height: ${1.height}");
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 0)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          textStyle: MaterialStateProperty.all(
              TextStyle(fontSize: context.px(10), fontWeight: FontWeight.w500)),
          fixedSize: MaterialStateProperty.all(Size(context.w(80), 0)),
          backgroundColor: MaterialStateProperty.all(Styles.defaultColor),
        ),
        child: Text(title));
  }
}
