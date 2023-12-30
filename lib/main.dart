import 'dart:io';

import 'package:checkofficer/states/main_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: '/mainCheck',
    page: () => const MainCheck(),
  )
];

void main() {
  HttpOverrides.global = MyHttpOverride();

  runApp(const MyApp());
}

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

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
