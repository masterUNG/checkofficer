import 'package:checkofficer/utility/app_constant.dart';
import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_dialog.dart';
import 'package:checkofficer/utility/app_service.dart';
import 'package:checkofficer/widgets/widget_button.dart';
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

  BitmapDescriptor? officerBitMapDescriptor;
  BitmapDescriptor? userBitMapDescriptor;

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)), 'images/office.png')
        .then((value) {
      officerBitMapDescriptor = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)), 'images/batman.png')
        .then((value) {
      userBitMapDescriptor = value;
    });

    AppService().processFindOfficer().then((value) {
      print('## จำนวนของ Officer --> ${appController.officerModels.length}');

      findPosition();
      refreshState();
    });
  }

  void findPosition() {
    AppService().processFindPosition().then((value) {
      if (appController.officerModels.isNotEmpty) {
        int i = 0;
        Map<MarkerId, Marker> officerMap = {};
        Map<CircleId, Circle> officerCircleMap = {};

        appController.officerModels.forEach((element) {
          i++;

          double distance = AppService().calculateDistance(
              appController.positions.last.latitude,
              appController.positions.last.longitude,
              double.parse(element.lat),
              double.parse(element.lng));

          if (distance <= AppConstant.checkInOutDistance) {
            //ได้ระยะในการทำ CheckInOut

            appController.checkInOutOfficerModels.add(element);

            print(
                '## ได้ระยะในการทำ CheckInOut  ---> ${appController.checkInOutOfficerModels.last.office}');
          }

          CircleId circleId = CircleId('id$i');
          Circle circle = Circle(
              circleId: circleId,
              center: LatLng(
                double.parse(element.lat),
                double.parse(element.lng),
              ),
              radius: AppConstant.checkInOutDistance,
              strokeWidth: 1,
              fillColor: Colors.green.withOpacity(0.25));

          officerCircleMap[circleId] = circle;

          MarkerId officerMarkerId = MarkerId('id$i');

          Marker officerMarker = Marker(
            markerId: officerMarkerId,
            position:
                LatLng(double.parse(element.lat), double.parse(element.lng)),
            icon: officerBitMapDescriptor!,
            infoWindow: InfoWindow(title: element.office),
          );

          officerMap[officerMarkerId] = officerMarker;
        });

        appController.markers.addAll(officerMap);
        appController.circles.addAll(officerCircleMap);
      }

      MarkerId markerId = const MarkerId('id');
      Marker marker = Marker(
          markerId: markerId,
          position: LatLng(appController.positions.last.latitude,
              appController.positions.last.longitude),
          icon: userBitMapDescriptor!,
          infoWindow: const InfoWindow(title: 'คุณอยู่ที่ีนี่'));

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
        //mySecond --> ค่าหน่วงในการเช็ค locotion
        mySecond = 0;
        findPosition();
      }

      refreshState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(
          '## appController.checkInOutOfficerModels.length -----> ${appController.checkInOutOfficerModels.length}');
      return Scaffold(
        appBar: AppBar(
          title: WidgetText(data: appController.displayDateTime.value),
        ),
        body: appController.positions.isEmpty
            ? const SizedBox()
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(appController.positions[0].latitude,
                          appController.positions[0].longitude),
                      zoom: 16,
                    ),
                    markers: Set<Marker>.of(appController.markers.values),
                    circles: Set<Circle>.of(appController.circles.values),
                  ),
                  appController.checkInOutOfficerModels.isEmpty
                      ? const SizedBox()
                      : Positioned(
                          bottom: 32,
                          child: Container(
                            margin: const EdgeInsets.only(left: 32),
                            child: WidgetButton(
                              label:
                                  'CheckInOut at ${appController.checkInOutOfficerModels.last.office}',
                              pressFunc: () {
                                AppDialog().normalDialog(
                                    title: 'Check IN-OUT',
                                    contentWidget: WidgetText(
                                        data:
                                            'Please Check In or Check Out at ${appController.checkInOutOfficerModels.last.office}'),
                                    firstActionWidget: WidgetButton(
                                      label: 'CheckIn',
                                      pressFunc: () {},
                                    ),
                                    secondActionWidget: WidgetButton(
                                      label: 'CheckOut',
                                      pressFunc: () {},
                                    ));
                              },
                            ),
                          ),
                        ),
                ],
              ),
      );
    });
  }
}
