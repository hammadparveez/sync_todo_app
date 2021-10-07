import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/widgets/bold_heading_widget.dart';
import 'package:notifications/ui/widgets/custom_form_widget.dart';
import 'package:notifications/ui/widgets/custom_textfield_labeled.dart';
import 'package:notifications/ui/widgets/default_elevated_button.dart';

class AddTodoItems extends StatefulWidget {
  const AddTodoItems({Key? key}) : super(key: key);

  @override
  _AddTodoItemsState createState() => _AddTodoItemsState();
}

class _AddTodoItemsState extends State<AddTodoItems> {
  final _globalFormKey = GlobalKey<FormState>();
  bool isOnline = false;
  late TextEditingController _titleController, _descriptionController;

  @override
  initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value!.isEmpty) return "Please enter a title";
  }

  String? _validateDesc(String? value) {
    if (value!.isEmpty) return "Please fill out description";
  }

  _onTap() async {
    FocusScope.of(context).unfocus();

    final isValidated = _globalFormKey.currentState?.validate() ?? false;

    if (isValidated) {
      WidgetUtils.showLoaderIndicator(context, "Loading");
      bool shouldCloseDialog = false;
      await Future.delayed(Duration(seconds: 1));
      if (!await hasConnection) {
        await Beamer.of(context).popRoute();
        WidgetUtils.showErrorBar(
            "An item will be synced as Internet connection establishes");
      } else {
        shouldCloseDialog = true;
      }

      await context
          .read(addTodoItemPod)
          .addItem(_titleController.text, _descriptionController.text);
      _titleController.clear();
      _descriptionController.clear();
      if (shouldCloseDialog) await Beamer.of(context).popRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: addTodoItemPod,
      onChange: (context, AddTodoItemService service) {
        log("Service Provider ${service.errMsg}");
        if (service.errMsg != null) WidgetUtils.showErrorBar(service.errMsg!);
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: context.fH() - kToolbarHeight,
              child: _buildTodoItemScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildTodoItemScreen() {
    return Column(
      children: [
        const Expanded(
            child: FractionallySizedBox(
                heightFactor: .6,
                widthFactor: .6,
                child: FittedBox(
                    child: BoldHeadingWidget(heading: "Add an Item")))),
        Expanded(
          flex: 4,
          child: CustomForm(
            formKey: _globalFormKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: _buildTitleField()),
                Flexible(flex: 2, child: _buildDescriptionField()),
                //_buildLocationShareCheck(),
                DefaultElevatedButton(onPressed: _onTap, title: "Add an Item"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  CustomTextFieldWithLabeled _buildTitleField() {
    return CustomTextFieldWithLabeled(
        controller: _titleController,
        label: "Title",
        hintText: "Enter a title",
        onValidate: _validateTitle,
        validationMode: AutovalidateMode.disabled,
        icon: Icons.add);
  }

  Widget _buildDescriptionField() {
    return CustomTextFieldWithLabeled(
        controller: _descriptionController,
        label: "Description",
        maxLines: null, //context.ifOrientation(5, 1),
        showOutlineBorder: true,
        hintText: "Enter a Description",
        onValidate: _validateDesc,
        validationMode: AutovalidateMode.disabled,
        icon: Icons.edit);
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Add items"),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Beamer.of(context).popRoute(),
        color: Styles.defaultColor,
        icon: Icon(Icons.arrow_back_ios),
      ),
    );
  }

  FormField<bool> _buildLocationShareCheck() {
    return FormField<bool>(validator: (val) {
      log("FormField-> $val");
      if (val != null && val)
        return null;
      else
        return "Please tap on Check Box";
    }, builder: (state) {
      return Column(
        children: [
          Row(
            children: [
              Checkbox(
                  value: state.value ?? false,
                  onChanged: (value) {
                    state.didChange(value);
                    log("Tapping $value and FormValue ${state.value}");
                  }),
              Text("Would you like to add current location?"),
            ],
          ),
          state.errorText == null ? const SizedBox() : Text(state.errorText!),
        ],
      );
    });
  }
}
