import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_service.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainCheck extends StatefulWidget {
  const MainCheck({super.key});

  @override
  State<MainCheck> createState() => _MainCheckState();
}

class _MainCheckState extends State<MainCheck> {
  AppController appController = Get.put(AppController());

  int mySecond = 0;

  @override
  void initState() {
    super.initState();

    AppService().processFindOfficer().then((value) => findPosition());

    refreshState();
  }

  void findPosition() {
    AppService().processFindPosition().then((value) {
      MarkerId markerId = const MarkerId('id');
      Marker marker = Marker(
          markerId: markerId,
          position: LatLng(appController.positions.last.latitude,
              appController.positions.last.longitude));

      Map<MarkerId, Marker> map = {};
      map[markerId] = marker;
      appController.markers.addAll(map);
    });
  }

  Future<void> refreshState() async {
    await Future.delayed(const Duration(seconds: 1), () {
      AppService().processFindDateTime();

      mySecond++;
      if (mySecond == 1) {
        mySecond = 0;
        findPosition();
      }

      refreshState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: WidgetText(data: appController.displayDateTime.value),
        ),
        body: appController.positions.isEmpty
            ? const SizedBox()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(appController.positions[0].latitude,
                      appController.positions[0].longitude),
                  zoom: 16,
                ),
                markers: Set<Marker>.of(appController.markers.values),
              ),
      );
    });
  }
}
