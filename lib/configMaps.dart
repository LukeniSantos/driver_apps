import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_apps/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/drivers.dart';

String mapKey = "AIzaSyCuBH7uNOGkVhFpKbmuIRIlxoK_82T6JOk_";

var firebaseUser;

Users userCurrentInfo = Users();

var currentfirebaseUser;

StreamSubscription<Position>? homeTabPageStreamSubscription;

StreamSubscription<Position>? rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

var currentPosition;

Drivers? driversInformation;

String title = "";
double starCounter = 0.0;

String rideType = "";
