import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifications/export.dart';

class ResponsiveVrtSpacer extends StatelessWidget {
  final double space;

  const ResponsiveVrtSpacer({Key? key, this.space = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: context.px(space));
  }
}

class ResponsiveHrtSpacer extends StatelessWidget {
  final double space;

  const ResponsiveHrtSpacer({Key? key, this.space = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return SizedBox(height:  context.px(space) );
  }
}
