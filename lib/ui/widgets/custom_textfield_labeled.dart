import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/widgets/spacer.dart';

class CustomTextFieldWithLabeled extends StatelessWidget {
  CustomTextFieldWithLabeled(
      {required this.label,
      required this.hintText,
      required this.icon,
      this.focusNode,
      this.suffixIcon,
      this.suffixColor,
      this.obscureText = false,
      this.onValidate,
      this.onChange,
      this.controller});

  final String label, hintText;
  final IconData icon;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final Color? suffixColor;
  final bool obscureText;
  final String? Function(String?)? onValidate;
  final Function(String?)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.px(2)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: context.px(4), color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.purple),
            child: TextFormField(
              focusNode: focusNode,
              validator: onValidate,
              controller: controller,
              obscureText: obscureText,
              onChanged: onChange,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: context.px(4)),
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: false,
                filled: false,
                contentPadding: EdgeInsets.only(bottom: 8),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: context.px(4),
                ),
                prefixIconConstraints: const BoxConstraints(),
                suffixIconConstraints: const BoxConstraints(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 8),
                  child: Icon(
                    icon,
                    color: Colors.grey,
                    size: context.px(7),
                  ),
                ),
                suffixIcon: suffixIcon != null
                    ? Icon(
                        suffixIcon,
                        size: context.px(7),
                        color: suffixColor ?? Colors.grey,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Another Bold Custom TextButton
class TextButtonDefaultBold extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TextButtonDefaultBold(
      {Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Styles.defaultColor)),
        onPressed: onTap,
        child: Text(title,
            style: TextStyle(
                fontSize: context.px(1), fontWeight: FontWeight.w600)));
  }
}
