// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.hint,
    this.validateFunc,
    this.textEditingController,
  }) : super(key: key);

  final String? hint;
  final String? Function(String?)? validateFunc;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: validateFunc,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey.shade300,
      ),
    );
  }
}
