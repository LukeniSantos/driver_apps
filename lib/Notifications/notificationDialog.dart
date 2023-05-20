import 'package:driver_apps/AllScreens/newRideScreen.dart';
import 'package:driver_apps/AllScreens/registrarscreen.dart';
import 'package:driver_apps/Models/ridedetails.dart';
import 'package:driver_apps/configMaps.dart';
import 'package:driver_apps/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails? rideDetails;

  NotificationDialog({this.rideDetails});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0),
            Image.asset("images/taxi.png", width: 120.0),
            SizedBox(height: 10.0),
            Text(
              "New Ride Request",
              style: TextStyle(fontFamily: "Brand Bold", fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(width: 20.0),
                      SizedBox(
                        child: Container(
                          child: Text(rideDetails!.pickup_address.toString(),
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Text(rideDetails!.dropoff_address.toString(),
                            style: TextStyle(fontSize: 18.0)),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Divider(height: 2.0, color: Colors.black, thickness: 2.0),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () {
                      checkAvailabilityOfRide(context);
                      assetsAudioPlayer.stop();
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context) {
    rideRequestRef.once().then((DatabaseEvent event) {
      Navigator.pop(context);
      String theRideId = "";
      if (event.snapshot.value != null) {
        theRideId = event.snapshot.value.toString();
      } else {
        displayToastMesenger("Ride not exist.", context);
      }

      if (theRideId == rideDetails!.ride_request_id) {
        rideRequestRef.set("accepted");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewRideScreen(rideDetails: rideDetails)));
      } else if (theRideId == "cancelled") {
        displayToastMesenger("Ride has been cancelled", context);
      } else if (theRideId == "timeout") {
        displayToastMesenger("Ride has been time out", context);
      } else {
        displayToastMesenger("Ride has time out", context);
      }
    });
  }
}
