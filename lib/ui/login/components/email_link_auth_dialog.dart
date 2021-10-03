import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/widgets/custom_textfield_labeled.dart';

class EmailLinkAuthDialog extends StatefulWidget {
  @override
  _EmailLinkAuthDialogState createState() => _EmailLinkAuthDialogState();
}

class _EmailLinkAuthDialogState extends State<EmailLinkAuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: "hammadpervez6@gmail.com");
  bool isLoaderOpened = false;

  Future<bool> _closeDialog() async => await Beamer.of(context).popRoute();

  String? _validate(String? value) {
    if (value!.isEmpty)
      return "Email required";
    else if (!value.isEmail) return "Email is not valid";
  }

  _sendEmailLink() async {
    final isValidated = _formKey.currentState!.validate();
    if (isValidated) {
      // networkCheckCallback(context, () async {

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
                onWillPop: () async {
                  log("Dialog: $isLoaderOpened");
                  if (isLoaderOpened) {
                    context.showInfoBar(
                        content: Text(
                            "Please wait... We are trying to send a link"));
                    return false;
                  }
                  return true;
                },
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text("We're sending a link..."),
                    ],
                  ),
                ),
              ));
      setState(() => isLoaderOpened = true);
      await Future.delayed(Duration(seconds: 2));
      final isSent =
          await context.read(loginPod).loginWithEmail(_emailController.text);
      setState(() => isLoaderOpened = false);
      //close loading dialog
      await _closeDialog();
      //close alertDialog

      await _closeDialog();

      if (isSent)
        WidgetUtils.snackBar(context,
            "Email has been sent, If you have not received, Resend it!");
      // });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (ctx, isKeyboardVisible) => AlertDialog(
        scrollable: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            _buildAlertDialogContent(isKeyboardVisible),
            _buildcloseIconButton(isKeyboardVisible),
            _isLandScapeAndKeyboardVisible(isKeyboardVisible)
                ? const SizedBox()
                : _buildEnvelopeImage(),
          ],
        ),
      ),
    );
  }

  Container _buildAlertDialogContent(bool isKeyboardVisible) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      //width: context.sqSize(80),
      padding: EdgeInsets.only(right: 10, left: 20, top: 5),
      margin: EdgeInsets.only(
          top: _isLandScapeAndKeyboardVisible(isKeyboardVisible)
              ? 0
              : context.px(12)),
      child: _textFieldWithButtons(),
    );
  }

  Widget _buildEnvelopeImage() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: SvgPicture.asset(
        'assets/icons/email-icon.svg',
        //height: 100,

        width: context.px(DefaultSizes.size20),
      ),
    );
  }

  Positioned _buildcloseIconButton(bool isKeyboardVisible) {
    return Positioned(
        top: _isLandScapeAndKeyboardVisible(isKeyboardVisible)
            ? 0
            : context.px(DefaultSizes.size10),
        right: 0,
        child: IconButton(
            iconSize: context.px(DefaultSizes.lSize),
            onPressed: _closeDialog,
            icon: Icon(Icons.close),
            color: Styles.defaultColor));
  }

  Column _textFieldWithButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          //width: context.px(400),
          child: Form(
            key: _formKey,
            child: CustomTextFieldWithLabeled(
                onValidate: _validate,
                label: "Email",
                hintText: "Type Email",
                controller: _emailController,
                icon: Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButtonDefaultBold(onTap: _sendEmailLink, title: "Send"),
            TextButtonDefaultBold(onTap: _closeDialog, title: "Close"),
          ],
        ),
      ],
    );
  }

  _isLandScapeAndKeyboardVisible(bool isKeyboardVisible) {
    return isKeyboardVisible &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
