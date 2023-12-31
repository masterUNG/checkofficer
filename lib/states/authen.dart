import 'package:checkofficer/widgets/widget_form.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 64),
                WidgetText(data: 'Login'),
                SizedBox(height: 16),
                WidgetForm(hint: 'User :'),
                SizedBox(height: 16),
                WidgetForm(hint: 'Password'),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
