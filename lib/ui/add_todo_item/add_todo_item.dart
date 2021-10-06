import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dns_client/dns_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notifications/domain/model/add_todo_item_model.dart';
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
  final _titleController = TextEditingController(text: "2 butter buns"),
      _descriptionController = TextEditingController(
          text: "I have bought 2 butter busn from Imtiaz Market");

  @override
  initState() {
    super.initState();
  }

  _onTap() async {
    final isValidated = _globalFormKey.currentState?.validate() ?? false;
    if (isValidated) {
      if (!await hasConnection)
        WidgetUtils.showErrorBar(
            "An item will be sync as Internet connection establishes");
      await context
          .read(addTodoItemPod)
          .addItem(_titleController.text, _descriptionController.text);
    } else
      WidgetUtils.snackBar(context, "Please fill out Title/Description");
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
              height: context.fH(),
              child: Column(
                children: [
                  Expanded(
                      child: FractionallySizedBox(
                          heightFactor: .6,
                          widthFactor: .6,
                          child: FittedBox(
                              child:
                                  BoldHeadingWidget(heading: "Add an Item")))),
                  Expanded(
                    flex: 3,
                    child: CustomForm(
                      formKey: _globalFormKey,
                      child: Column(
                        children: [
                          _buildTitleField(),
                          const SizedBox(height: 8),
                          _buildDescriptionField(),
                          //_buildLocationShareCheck(),
                          DefaultElevatedButton(
                              onPressed: _onTap, title: "Add an Item"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomTextFieldWithLabeled _buildTitleField() {
    return CustomTextFieldWithLabeled(
        controller: _titleController,
        label: "Title",
        hintText: "Enter a title",
        icon: Icons.add);
  }

  CustomTextFieldWithLabeled _buildDescriptionField() {
    return CustomTextFieldWithLabeled(
        controller: _descriptionController,
        label: "Description",
        hintText: "Enter a Description",
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
