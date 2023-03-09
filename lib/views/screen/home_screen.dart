import 'package:busrm/views/bus_list_screen/bus_list_screen.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:busrm/models/directions_response.dart';
import 'package:busrm/controllers/map_controller.dart';
import 'package:busrm/models/polyline_response.dart';
import 'package:busrm/models/direction_model.dart';
import 'package:busrm/data/temp_coordinated.dart';
import 'package:geolocator/geolocator.dart';
import 'package:busrm/data/bus_stops.dart';
import 'package:busrm/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController pickUpTextController = TextEditingController();
  TextEditingController dropToTextController = TextEditingController();
  var MapController = Get.put(mapController());
  late AnimationController animationController;
  final panelController = PanelController();
  PolylineResponse polylineResponse = PolylineResponse();
  String apiKey = "";

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(12.822930, 80.041131),
    zoom: 18,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SlidingUpPanel(
          color: Colors.transparent,
          minHeight: 80,
          maxHeight: 300,
          defaultPanelState: PanelState.CLOSED,
          controller: panelController,
          parallaxEnabled: true,
          onPanelClosed: () {
            animationController.reverse();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onPanelOpened: () {
            animationController.forward();
          },
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GetBuilder<mapController>(
                  init: mapController(),
                  builder: (MapController) => GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (controller) {
                      _googleMapController = controller;
                      MapController.addMarker(
                        "SRM",
                        LatLng(MapController.lati.value,
                            MapController.longi.value),
                        "SRM IST",
                      );
                    },
                    markers: {
                      if (_origin != null) _origin!,
                      if (_destination != null) _destination!
                    },
                    polylines: {
                      if (_info != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          points: _info!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                    //onLongPress: _addMarker,
                  ),
                ),
                /*GetBuilder<mapController>(
                  init: mapController(),
                  builder: (MapController) => GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          12.822930061884765, 80.04113176677102 //SRM IST LATLNG
                          ),
                      zoom: 18,
                    ),
                    zoomControlsEnabled: false,
                    polylines: MapControllerr.polylinePoints,
                    onMapCreated: (controller) {
                      gmapController = controller;
                      MapController.addMarker(
                          "SRM",
                          LatLng(MapController.lati.value,
                              MapController.longi.value),
                          "SRM IST");
                    },
                    mapType: MapType.normal,
                    compassEnabled: false,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    indoorViewEnabled: false,
                    mapToolbarEnabled: false,
                    markers: MapController.markers.values.toSet(),
                  ),
              ),*/
                Positioned(
                  top: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 55,
                    decoration: BoxDecoration(
                        color: bgColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            spreadRadius: -10,
                            offset: Offset(0, 8),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: AnimatedIconButton(
                              animationController: animationController,
                              onPressed: () {
                                panelController.isPanelOpen
                                    ? panelController.close()
                                    : panelController.open();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              icons: [
                                AnimatedIconItem(
                                  icon: Icon(
                                    Icons.menu,
                                    size: 20,
                                    color: bgColor,
                                  ),
                                ),
                                AnimatedIconItem(
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: bgColor,
                                  ),
                                ),
                              ],
                              duration: Duration(milliseconds: 200),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: orange),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(busList()),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Icon(Icons.directions_bus_rounded,
                                  size: 20, color: bgColor),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: orange),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          panel: Container(
            width: MediaQuery.of(context).size.width,
            height: 270,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  spreadRadius: -10,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 3,
                  decoration: BoxDecoration(
                    color: ink,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Position position = await liveLocation();

                        MapController.addMarker(
                            "currentLocation",
                            LatLng(position.latitude, position.longitude),
                            "You");

                        //_addMarker(LatLng(position.latitude, position.longitude));

                        /*drawPolyline(
                          LatLng(position.latitude, position.longitude),
                          LatLng(12.822930061884765, 80.04113176677102),
                        );*/

                        _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(
                                  position.latitude,
                                  position.longitude,
                                ),
                                zoom: 18),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: Container(
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Icon(
                                  Icons.directions_bus_rounded,
                                  color: bgColor,
                                  size: 24,
                                ),
                              ),
                              Text(
                                '  Ride    ',
                                style: TextStyle(
                                  color: bgColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                            color: ink,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Icon(
                                Icons.alarm_on_outlined,
                                color: bgColor,
                                size: 24,
                              ),
                            ),
                            Text('  Alert    ',
                                style: TextStyle(
                                    color: bgColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Container(
                        width: 45,
                        height: 45,
                        child: Icon(Icons.history_rounded,
                            size: 25, color: bgColor),
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: ink),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                      color: Color(0xffDCDCDC),
                      borderRadius: BorderRadius.circular(10)),
                  child: EasyAutocomplete(
                    controller: pickUpTextController,
                    suggestionBackgroundColor: grey,
                    suggestionBuilder: (a) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: Container(
                          color: grey,
                          width: MediaQuery.of(context).size.width - 40,
                          height: 20,
                          child: Text(a),
                        ),
                      );
                    },
                    onChanged: (a) {},
                    onSubmitted: (a) {},
                    cursorColor: ink,
                    suggestions: busStopList,
                    inputTextStyle: TextStyle(
                      color: ink,
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      focusColor: ink,
                      fillColor: ink,
                      border: InputBorder.none,
                      hintText: 'Pick up',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ink,
                        letterSpacing: 1,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Icon(
                          Icons.search_rounded,
                          color: ink,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                      color: Color(0xffDCDCDC),
                      borderRadius: BorderRadius.circular(10)),
                  child: EasyAutocomplete(
                    controller: dropToTextController,
                    suggestionBackgroundColor: grey,
                    suggestionBuilder: (a) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: Container(
                          color: grey,
                          width: MediaQuery.of(context).size.width - 40,
                          height: 20,
                          child: Text(a),
                        ),
                      );
                    },
                    onChanged: (a) {},
                    onSubmitted: (a) {},
                    cursorColor: ink,
                    suggestions: busStopList,
                    inputTextStyle: TextStyle(
                      color: ink,
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      focusColor: ink,
                      fillColor: ink,
                      border: InputBorder.none,
                      hintText: 'Drop to',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ink,
                        letterSpacing: 1,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Icon(
                          Icons.search_rounded,
                          color: ink,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _addMarker(tempLocations[pickUpTextController.text]!,
                        tempLocations[dropToTextController.text]!);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                        color: ink, borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.alarm_on_outlined,
                            color: bgColor,
                            size: 24,
                          ),
                        ),
                        Text(
                          '  Search  ',
                          style: TextStyle(
                              color: bgColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> liveLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: false);

    return position;
  }

  void _addMarker(LatLng pickUp, LatLng dropAt) async {

    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origin'),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pickUp,
    );
    _destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'Destination'),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: dropAt,
    );

    final directions = await DirectionsRepository().getDirections(
      origin: pickUp,
      destination: dropAt,
    );

    _info = directions;
    MapController.addPolylinesUpdate();

    _googleMapController.animateCamera(
      _info != null
          ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
          : CameraUpdate.newCameraPosition(_initialCameraPosition),
    );

  }
}
