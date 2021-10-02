import 'package:notifications/export.dart';

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
          top: context.px(0), left: context.px(10), right: context.px(10)),
      child: Form(
        key: _formKey,
        child: child,
      ),
    );
  }
}
