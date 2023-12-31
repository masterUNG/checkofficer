import 'package:checkofficer/models/check_in_model.dart';
import 'package:checkofficer/models/officer_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppController extends GetxController {
  RxList<Position> positions = <Position>[].obs;

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  RxMap<CircleId, Circle> circles = <CircleId, Circle>{}.obs;

  RxString displayDateTime = ''.obs;

  RxList<OfficerModel> officerModels = <OfficerModel>[].obs;

  RxList<OfficerModel> checkInOutOfficerModels = <OfficerModel>[].obs;

  RxList<CheckInModel> checkInModels = <CheckInModel>[].obs;

  RxBool displayCheeckOut = false.obs;
}
