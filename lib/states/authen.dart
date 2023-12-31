import 'package:checkofficer/utility/app_service.dart';
import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_form.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),
                  const WidgetText(data: 'Login'),
                  const SizedBox(height: 16),
                  WidgetForm(
                    textEditingController: userController,
                    hint: 'User :',
                    validateFunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'Please Fill User';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  WidgetForm(
                    textEditingController: passwordController,
                    hint: 'Password',
                    validateFunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'Please Fill Password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  WidgetButton(
                    label: 'Login',
                    pressFunc: () {
                      if (formKey.currentState!.validate()) {
                        AppService().processCheckAuthen(
                            user: userController.text,
                            password: passwordController.text);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
