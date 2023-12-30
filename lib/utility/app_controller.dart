import 'package:checkofficer/models/officer_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppController extends GetxController {
  RxList<Position> positions = <Position>[].obs;

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  RxString displayDateTime = ''.obs;

  RxList<OfficerModel> officerModels = <OfficerModel>[].obs;
}
