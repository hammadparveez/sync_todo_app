import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';

class DefaultElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? width;
  const DefaultElevatedButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 0)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          //textStyle:MaterialStateProperty.all(),
          fixedSize: MaterialStateProperty.all(
              Size.fromWidth(this.width ?? context.px(50))),
          backgroundColor: MaterialStateProperty.all(Styles.defaultColor),
        ),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)));
  }
}
