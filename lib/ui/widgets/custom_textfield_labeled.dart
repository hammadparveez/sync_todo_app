import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';


class CustomTextFieldWithLabeled extends StatelessWidget {
  CustomTextFieldWithLabeled(
      {Key? key,
      required this.label,
      required this.hintText,
      required this.icon,
      this.focusNode,
      this.suffixIcon,
      this.suffixColor,
      this.obscureText = false,
      this.onValidate,
      this.onChange,
      this.maxLines = 1,
      this.expands = false,
      this.showOutlineBorder = false,
      this.validationMode = AutovalidateMode.onUserInteraction,
      this.controller})
      : super(key: key);

  final String label, hintText;
  final AutovalidateMode validationMode;
  final IconData icon;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final Color? suffixColor;
  final bool obscureText, showOutlineBorder, expands;
  final int? maxLines;
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
          Text(label),
          const SizedBox(height: 8),
          Flexible(
            flex: 2,
            child: TextFormField(
              autovalidateMode: validationMode,

              focusNode: focusNode,
              validator: onValidate,
              controller: controller,
              obscureText: obscureText,
              expands: expands,
              onChanged: onChange,
              textAlignVertical: TextAlignVertical.top,
              maxLines: maxLines,

              // style: TextStyle(fontSize: context.px(DefaultSizes.mSize)),
              decoration: InputDecoration(
                border: showOutlineBorder ? OutlineInputBorder() : null,
                isCollapsed: true,
                isDense: false,
                filled: false,
                contentPadding: EdgeInsets.all(5),
                hintText: hintText,
                prefixIconConstraints: const BoxConstraints(),
                suffixIconConstraints: const BoxConstraints(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 2, bottom: 0),
                  child: Icon(
                    icon,
                    color: Colors.grey,
                    size: context.px(DefaultSizes.size6),
                  ),
                ),
                suffixIcon: suffixIcon != null
                    ? Icon(
                        suffixIcon,
                        size: context.px(DefaultSizes.mSize),
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
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w600)));
  }
}
