import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapController extends GetxController {
  Map<String, Marker> markers = {};
  RxDouble lati = 12.822930061884765.obs;
  RxDouble longi = 80.04113176677102.obs;
  Set<Polyline> polylinePoints = {};

  @override
  void onInit() {
    super.onInit();
    //loadLocation();
  }


/*
  loadLocation() async{
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: false)
        .then((position) {
          lati.value = position.latitude;
          longi.value = position.longitude;
      print("This is Updated position -> ${position}");
      print("This is Gmap position -> ${lati.value}, ${longi.value}");
    });

  }*/

  addPolylinesUpdate() {
    update();
  }

  addMarker(String id, LatLng location, String title) {
    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: InfoWindow(
          title: title,
        ));

    markers[id] = marker;
    update();
  }
}
