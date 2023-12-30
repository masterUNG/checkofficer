import 'package:checkofficer/states/main_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: '/mainCheck',
    page: () => const MainCheck(),
  )
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: getPages,
      initialRoute: '/mainCheck',
      theme: ThemeData(useMaterial3: true),
    );
  }
}
