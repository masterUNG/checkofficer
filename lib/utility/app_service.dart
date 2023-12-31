import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:checkofficer/models/check_in_model.dart';
import 'package:checkofficer/models/officer_model.dart';
import 'package:checkofficer/models/user_model.dart';
import 'package:checkofficer/utility/app_constant.dart';
import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_dialog.dart';
import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class AppService {
  AppController appController = Get.put(AppController());

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a)) * 1000;

    return distance;
  }

  Future<void> processFindOfficer() async {
    await Dio().get(AppConstant.urlApiGetAllOffiecer).then((value) {
      json.decode(value.data).forEach((element) {
        print('## $element');

        OfficerModel officerModel = OfficerModel.fromMap(element);

        print('## officeModel --> ${officerModel.toMap()}');

        appController.officerModels.add(officerModel);
      });
    });
  }

  void processFindDateTime() {
    DateFormat dateFormat = DateFormat('dd/MM/yy HH:mm:ss');
    String string = dateFormat.format(DateTime.now());
    appController.displayDateTime.value = string;
  }

  Future<void> processFindPosition() async {
    bool locationService = await Geolocator.isLocationServiceEnabled();

    if (locationService) {
      //OpenLocation

      LocationPermission locationPermission =
          await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.deniedForever) {
        //deniedForver
        dialogSetPermission();
      } else {
        // One, All, denined

        if (locationPermission == LocationPermission.denied) {
          // Denindd

          locationPermission = await Geolocator.requestPermission();

          if ((locationPermission != LocationPermission.always) &&
              (locationPermission != LocationPermission.whileInUse)) {
            dialogSetPermission();
          } else {
            Position position = await Geolocator.getCurrentPosition();
            appController.positions.add(position);
          }
        } else {
          // All, One
          Position position = await Geolocator.getCurrentPosition();
          appController.positions.add(position);
        }
      }
    } else {
      //OffLocation
      AppDialog().normalDialog(
          title: 'Location OFF',
          contentWidget: const WidgetText(
              data: 'Please Open Location Service for Get Your Location'),
          actionWidget: WidgetButton(
            label: 'Open Service',
            pressFunc: () {
              Geolocator.openLocationSettings().then((value) => exit(0));
            },
          ));
    }
  }

  void dialogSetPermission() {
    AppDialog().normalDialog(
        title: 'Location NonPermission',
        contentWidget:
            const WidgetText(data: 'Please Open Permission Location'),
        actionWidget: WidgetButton(
          label: 'Open Permission',
          pressFunc: () {
            Geolocator.openAppSettings().then((value) => exit(0));
          },
        ));
  }

  Future<void> processCheckAuthen(
      {required String user, required String password}) async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/min/getUserWhereUserOfficer.php?isAdd=true&user=$user';

    await Dio().get(urlAPI).then((value) async {
      if (value.toString() == 'null') {
        AppDialog().normalDialog(title: 'User Fasle');
      } else {
        var response = json.decode(value.data);
        response.forEach((element) async {
          UserModel userModel = UserModel.fromMap(element);

          if (password == userModel.password) {
            //Password True

            await GetStorage().write('data', userModel.toMap()).then((value) {
              Get.offAllNamed('/mainCheck');
            });
          } else {
            AppDialog().normalDialog(title: 'Password False');
          }
        });
      }
    });
  }

  Future<void> processSignOut() async {
    await GetStorage().erase().then((value) => Get.offAllNamed('/authen'));
  }

  Future<void> processCheckIn() async {
    UserModel userModel = UserModel.fromMap(GetStorage().read('data'));
    print(
        '##31dec นี่คือ userModel ที่ได้มาจาก GetStorage ---> ${userModel.toMap()}');

    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/min/insertCheckIn.php?isAdd=true&idUser=${userModel.id}&idOffice=${appController.checkInOutOfficerModels.last.id}&dataCheck=${timeToString(formatString: 'dd/MM/yyyy')}&checkIn=${timeToString(formatString: 'HH:mm')}';

    await Dio().get(urlAPI).then((value) {
      Get.back();
      Get.snackbar('Check In Success', 'Welcome to Office');
    });
  }

  String timeToString({required String formatString}) {
    DateFormat dateFormat = DateFormat(formatString);
    return dateFormat.format(DateTime.now());
  }

  Future<void> checkStatusInOut() async {
    UserModel userModel = UserModel.fromMap(GetStorage().read('data'));

    String urlApi =
        'https://www.androidthai.in.th/fluttertraining/min/checkUser.php?isAdd=true&idUser=${userModel.id}&idOffice=${appController.checkInOutOfficerModels.last.id}&dataCheck=${timeToString(formatString: 'dd/MM/yyyy')}';

    await Dio().get(urlApi).then((value) {
      if (value.toString() != 'null') {
        appController.displayCheeckOut.value = true;

        json.decode(value.data).forEach((element) {
          CheckInModel checkInModel = CheckInModel.fromMap(element);
          appController.checkInModels.add(checkInModel);
        });
      }
    });
  }

  Future<void> processCheckOut() async {
    String urlApi =
        'https://www.androidthai.in.th/fluttertraining/min/checkOutUser.php?isAdd=true&id=${appController.checkInModels.last.id}&checkOut=${timeToString(formatString: 'HH:mm')}';

    await Dio().get(urlApi).then((value) => Get.back());
  }
}
