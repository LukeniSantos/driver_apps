import 'package:flutter/cupertino.dart';
import 'package:driver_apps/Models/address.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int tripCount = 0;

  void updateEarnings(String updateEarnings) {
    earnings = updateEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter) {
    tripCount = tripCounter;
    notifyListeners();
  }
}
