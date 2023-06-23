import 'package:driver_apps/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_apps/AllScreens/mainscreen.dart';
import 'package:driver_apps/AllScreens/registrarscreen.dart';
import 'package:driver_apps/AllWidgets/progressDialog.dart';
import 'package:driver_apps/main.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Serviço de localização desabilitado");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permissão de localização negada");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Permissão de localização negada permanentemente");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/logo.png"),
                  width: size.width * 1,
                  height: size.width * 0.7,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 30.0),
                Text(
                  "Login as a Driver",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                Container(
                  width: size.width * 0.9,
                  child: TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: size.width * 0.9,
                  child: TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!emailTextEditingController.text.contains("@")) {
                        displayToastMesenger("Email inválido", context);
                      } else if (passwordTextEditingController.text.isEmpty) {
                        displayToastMesenger("Senha é obrigatória", context);
                      } else {
                        _getCurrentLocation();
                        loginAndAuthenticateUser(context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login"),
                          Icon(Icons.login_rounded),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    _getCurrentLocation();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RegistrarScreen.idScreen,
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Não tem conta? Registre-se aqui.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Autenticando, por favor espere...",
        );
      },
    );

    final firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((errMsg) {
      displayToastMesenger("Erro: $errMsg", context);
    }))
        .user;

    if (firebaseUser != null) {
      DataSnapshot snap;
      driverRef.child(firebaseUser.uid).once().then((snap) {
        if (snap.snapshot.exists) {
          currentfirebaseUser = firebaseUser;

          Navigator.pushNamedAndRemoveUntil(
            context,
            MainScreen.idScreen,
            (route) => false,
          );
          displayToastMesenger("Seja bem-vindo", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMesenger(
            "Usuário inexistente, crie uma conta.",
            context,
          );
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMesenger("Email ou senha incorretos", context);
    }
  }
}
