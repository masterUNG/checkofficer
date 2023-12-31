import 'dart:io';

import 'package:checkofficer/states/authen.dart';
import 'package:checkofficer/states/main_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: '/mainCheck',
    page: () => const MainCheck(),
  ),
  GetPage(
    name: '/authen',
    page: () => const Authen(),
  ),
];

String? firstPage;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init().then((value) {
    var data = GetStorage().read('data');
    print('## data ที่ได้จาก GetStorage ---> $data');

    if (data == null) {
      //Non Login
      firstPage = '/authen';
      runApp(const MyApp());
    } else {
      //Logined
      firstPage = '/mainCheck';
      runApp(const MyApp());
    }
  });

  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: getPages,
      initialRoute: firstPage,
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
