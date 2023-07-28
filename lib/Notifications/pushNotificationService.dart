import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_apps/Notifications/notificationDialog.dart';
import 'package:driver_apps/configMaps.dart';
import 'package:driver_apps/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Models/ridedetails.dart';
import 'dart:io' show Platform;
import 'dart:async';

class PushNotificationService {
  FirebaseMessaging mensagem = FirebaseMessaging.instance;

  Future initialize(context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      retrieveRideRequestInfo(getRideRequestId(message), context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        getRideRequestId(message);
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
    );
  }

  Future<String> getToken() async {
    String? token = await mensagem.getToken();

    print("TOKEN");
    print("****$token");

    driverRef.child(currentfirebaseUser.uid).child("token").set(token);

    mensagem.subscribeToTopic("alldrivers");
    mensagem.subscribeToTopic("allriders");
    if (token != null) {
      return token;
    } else {
      return "null";
    }
  }

  String getRideRequestId(RemoteMessage message) {
    String rideRequestId = "";

    if (Platform.isAndroid) {
      rideRequestId = message.data['ride_request_id'];
    } else {
      rideRequestId = message.data['ride_request_id'];
    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(
      String rideRequestId, BuildContext context) async {
    newRequestsRef.child(rideRequestId).once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        var assetsAudioPlayer = AssetsAudioPlayer();
        assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetsAudioPlayer.play();
        final value = event.snapshot.value as Map;
        double pickupLocationLat =
            double.parse(value['pickup']['latitude'].toString());
        double pickupLocationLng =
            double.parse(value['pickup']['longitude'].toString());
        String pickupAddress = value['pickup_address'].toString();
        double dropoffLocationLat =
            double.parse(value['dropoff']['latitude'].toString());
        double dropoffLocationLng =
            double.parse(value['dropoff']['longitude'].toString());
        String dropoffAddress = value['dropoff_address'].toString();

        String paymentMethod = value['payment_method'].toString();

        String rider_name = value["rider_name"].toString();
        String rider_phone = value["rider_phone"].toString();

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickupAddress;
        rideDetails.dropoff_address = dropoffAddress;
        rideDetails.pickup = LatLng(pickupLocationLat, pickupLocationLng);
        rideDetails.dropoff = LatLng(dropoffLocationLat, dropoffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.rider_phone = rider_phone;

        print("Information :: ");
        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              NotificationDialog(rideDetails: rideDetails),
        );
      }
    });
  }
}
