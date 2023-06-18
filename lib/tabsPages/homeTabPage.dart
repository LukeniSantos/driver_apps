import 'package:driver_apps/Notifications/pushNotificationService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_apps/AllScreens/registrarscreen.dart';
import 'package:driver_apps/Assistants/assistanMethods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_apps/configMaps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driver_apps/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../Models/drivers.dart';

class HomeTabPage extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-8.838333, 13.234444),
    zoom: 14,
  );

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  /**
   * Texte começa aqui 
   */

  Future<Position> _getcurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("serviço desabilitado");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permissão está negada mesmo");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Está negado pra toda vida");
    }
    return await Geolocator.getCurrentPosition();
  }

  /**
   * Texte Termina aqui 
   */

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();

  String driverStatusText = "Offline Now - Go Online";

  Color driverStatusColor = Colors.black;

  bool isDriversAvailable = false;

  @override
  void initState() {
    super.initState();
    _getcurrentLocation();
    getCurrentDriverInfo();
  }

  void locatePosition() async {
    _getcurrentLocation();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 13);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String adress = await AssistantMethods.searchCoordinateAdress(position, context);
    // print("******************This is your Adress:: " + adress + "****************");
  }

  void getCurrentDriverInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    driverRef.child(currentfirebaseUser.uid).once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        driversInformation = Drivers.fromSnapshot(event.snapshot);
      }
    });

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

        //Online e ofline Driver container
        Container(
          height: 140,
          width: double.infinity,
          color: Colors.black54,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isDriversAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online now";
                        isDriversAvailable = true;
                      });
                      displayToastMesenger("You are online Now", context);
                    } else {
                      makeDriverOfflineNow();
                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online";
                        isDriversAvailable = false;
                      });

                      displayToastMesenger("You are offline Now", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: driverStatusColor),
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          driverStatusText,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriversAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentfirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
  }
}
