import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.child,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: context.px(DefaultSizes.mSize),
          right: context.px(DefaultSizes.mSize)),
      child: Form(
        key: _formKey,
        child: child,
      ),
    );
  }
}
