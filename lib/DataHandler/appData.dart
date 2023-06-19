import 'package:driver_apps/Models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:driver_apps/Models/address.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateEarnings(String updateEarnings) {
    earnings = updateEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter) {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }
}
