/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final PushNotificationService notificationService;

  PushNotificationService(this.notificationService);

  Future initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    getDeviceFirebaseToken();
    _onMessage();
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("==================================");
    debugPrint("TOKEN $token");
    debugPrint("==================================");
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {notificationService.}
    });
  }
}
*/

/*
import 'package:driver_apps/configMaps.dart';
import 'package:driver_apps/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  FirebaseMessaging mensagem = FirebaseMessaging.instance;

  void requestPermission() async {
    NotificationSettings settings = await mensagem.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Usuario granted premission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Usuario granted provisional premission");
    } else {
      print("Usuario Negou todas oermissões premission");
    }
  }

  Future inicialize() async {
    FirebaseMessaging.onMessage.listen((event) {
      // fetchRideInfo(getRideID(message), context);
      (Map<String, dynamic> message) async {
        print("onMessage: $message");
      };
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // fetchRideInfo(getRideID(message), context);
      (Map<String, dynamic> message) async {
        print("onMessageOpenedApp: $message");
      };
    });
  }

  Future<String> getToken() async {
    String? token = await mensagem.getToken();

    print("TOKENNNNNNNNNNNNNNN");
    print("*********************$token");

    driverRef.child(currentfirebaseUser.uid).child("token").set(token);

    mensagem.subscribeToTopic("alldrivers");
    mensagem.subscribeToTopic("allriders");
    if (token != null) {
      return token;
    } else {
      return "null";
    }
  }
}
*/
