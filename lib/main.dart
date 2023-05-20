import 'package:driver_apps/AllScreens/carInfoScreen.dart';
import 'package:driver_apps/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:driver_apps/AllScreens/registrarscreen.dart';
import 'package:driver_apps/AllScreens/loginscreen.dart';
import 'package:driver_apps/AllScreens/mainscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:driver_apps/DataHandler/appData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.ref().child("Ride Request");
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .ref()
    .child("drivers")
    .child(currentfirebaseUser.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Taxi Driver App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.yellow[600],
          brightness: Brightness.light,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegistrarScreen.idScreen: (context) => RegistrarScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
