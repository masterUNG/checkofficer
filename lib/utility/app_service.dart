import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:checkofficer/models/officer_model.dart';
import 'package:checkofficer/utility/app_constant.dart';
import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_dialog.dart';
import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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
}
