import 'package:notifications/export.dart';

class AddTodoItems extends StatefulWidget {
  const AddTodoItems({Key? key}) : super(key: key);

  @override
  _AddTodoItemsState createState() => _AddTodoItemsState();
}

class _AddTodoItemsState extends State<AddTodoItems> {
  final _globalFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: "2 butter buns"),
      _descriptionController = TextEditingController(
          text: "I have bought 2 butter busn from Imtiaz Market");

  _onTap() {
    final validate = _globalFormKey.currentState?.validate() ?? false;
    if (validate) {
      context
          .read(addTodoItemPod)
          .addItem(_titleController.text, _descriptionController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add items")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _globalFormKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: "Enter title"),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(hintText: "Enter Description"),
                  ),
                  FormField<bool>(validator: (val) {
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
                        Text((state.errorText ?? "No Error")),
                      ],
                    );
                  }),
                  ElevatedButton(onPressed: _onTap, child: Text("Add Item")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
