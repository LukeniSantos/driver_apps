import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String? name;
  String? phone;
  String? email;
  String? id;
  String? car_color;
  String? car_model;
  String? car_number;

  Drivers({
    this.name,
    this.phone,
    this.email,
    this.id,
    this.car_color,
    this.car_model,
    this.car_number,
  });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    final value = dataSnapshot.value as Map;
    phone = value["phone"];
    email = value["email"];
    name = value["name"];
    car_color = value["car_details"]["car_color"];
    car_model = value["car_details"]["car_model"];
    car_number = value["car_details"]["car_number"];
  }
}
