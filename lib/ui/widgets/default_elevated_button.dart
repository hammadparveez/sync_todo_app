import 'package:notifications/export.dart';


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
          fixedSize: MaterialStateProperty.all(
              Size.fromWidth(this.width ?? context.px(50))),
        ),
        child: Text(title));
  }
}
