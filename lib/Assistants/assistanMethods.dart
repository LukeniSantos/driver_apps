import 'package:driver_apps/Models/history.dart';
import 'package:driver_apps/main.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:driver_apps/Assistants/resquestAssistants.dart';
import 'package:driver_apps/DataHandler/appData.dart';
import 'package:driver_apps/Models/directDetails.dart';
import 'package:driver_apps/configMaps.dart';

class AssistantMethods {
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng inicialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${inicialPosition.latitude},${inicialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    //maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=YOUR_API_KEY
    var res = await RequestAssistat.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distancTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFireAmount = timeTraveledFare + distancTraveledFare;

    // 1$ = 160 rs
    //double totalLocalAmount = totalFireAmount * 160;

    if (rideType == "uber-x") {
      double result = (totalFireAmount.truncate()) * 2.0;
      return result.truncate();
    } else if (rideType == "uber-go") {
      return totalFireAmount.truncate();
    } else if (rideType == "bike") {
      double result = (totalFireAmount.truncate()) / 2.0;
      return result.truncate();
    } else {
      return totalFireAmount.truncate();
    }
  }

  static void disablehomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.pause();
    Geofire.removeLocation(currentfirebaseUser.uid);
  }

  static void enablehomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void retrieveHistoryInfo(context) {
    //retried and display earnings
    driverRef
        .child(currentfirebaseUser.uid)
        .child("earnings")
        .once()
        .then((data) {
      if (data.snapshot.value != null) {
        String earnings = data.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    //retried and display trip history
    driverRef
        .child(currentfirebaseUser.uid)
        .child("history")
        .once()
        .then((data) {
      if (data.snapshot.value != null) {
        //update total number of trip counts to provide
        Map<dynamic, dynamic> keys = data.snapshot.value as Map;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripsCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestHistoryData(context);
      }
    });
  }

  static void obtainTripRequestHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      newRequestsRef.child(key).once().then((data) {
        if (data.snapshot.value != null) {
          var history = History.fromSnapshot(data.snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
