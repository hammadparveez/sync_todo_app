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
    //log("Button Height: ${1.height}");
    return LayoutBuilder(builder: (context, cons) {
      log("Layout Button Builder -> ${cons.maxWidth}");
      return ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 0)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
            textStyle: MaterialStateProperty.all(TextStyle(
                fontSize: context.px(DefaultSizes.mSize),
                fontWeight: FontWeight.w500)),
            fixedSize: MaterialStateProperty.all(Size(
                this.width ?? context.px(50), context.px(DefaultSizes.size9))),
            backgroundColor: MaterialStateProperty.all(Styles.defaultColor),
          ),
          child: Text(title));
    });
  }
}
