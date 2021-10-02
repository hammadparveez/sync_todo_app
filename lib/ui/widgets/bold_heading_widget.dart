import 'package:notifications/export.dart';

class BoldHeadingWidget extends StatelessWidget {
  final String heading;

  const BoldHeadingWidget({Key? key, required this.heading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(heading,
        style:
            TextStyle(fontSize: context.px(20), fontWeight: FontWeight.bold));
  }
}
