import 'package:driver_apps/AllScreens/mainscreen.dart';
import 'package:driver_apps/AllScreens/registrarscreen.dart';
import 'package:driver_apps/configMaps.dart';
import 'package:driver_apps/main.dart';
import 'package:flutter/material.dart';

class CarInfoScreen extends StatelessWidget {
  static const String idScreen = "carinfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  String? selectedCarType;
  List<String> carTypeList = ["Carro", "Motorizada"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 22.0,
            ),
            Image.asset(
              "images/logo.png",
              width: 390.0,
              height: 250.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Enter Car details",
                    style: TextStyle(fontFamily: "Brand-Bold", fontSize: 24.0),
                  ),
                  SizedBox(height: 26.0),
                  TextField(
                    controller: carModelTextEditingController,
                    decoration: InputDecoration(
                      labelText: "Modelo do carro",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: carNumberTextEditingController,
                    decoration: InputDecoration(
                      labelText: "matricula do carro",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: carColorTextEditingController,
                    decoration: InputDecoration(
                      labelText: "Cor do carro",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 26.0),
                  DropdownButton(
                    iconSize: 40,
                    hint: Text("Tipo de veiculo"),
                    value: selectedCarType,
                    onChanged: (newValue) {
                      selectedCarType = newValue;
                      displayToastMesenger(selectedCarType!, context);
                    },
                    items: carTypeList.map((car) {
                      return DropdownMenuItem(
                        child: new Text(car),
                        value: car,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 42.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (carModelTextEditingController.text.isEmpty) {
                          displayToastMesenger(
                              "Por favor informe o modelo do veiculo.",
                              context);
                        } else if (carNumberTextEditingController
                            .text.isEmpty) {
                          displayToastMesenger(
                              "Por favor informe numero da matricula do veiculo.",
                              context);
                        } else if (carColorTextEditingController.text.isEmpty) {
                          displayToastMesenger(
                              "Por favor informe a cor do veiculo.", context);
                        } else if (selectedCarType == null) {
                          displayToastMesenger(
                              "Por favor informe o tipo de veiculo.", context);
                        } else {
                          saveDriverCarInfo(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward,
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
        ),
      )),
    );
  }

  void saveDriverCarInfo(context) {
    String userId = currentfirebaseUser.uid;

    if (selectedCarType == "Carro") {
      selectedCarType = "uber-go";
    } else {
      selectedCarType = "bike";
    }
    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
      "type": selectedCarType,
    };

    driverRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }
}
