// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:tbd_foods/barcode_managment/barcode_manager.dart';
import 'package:tbd_foods/user_management/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(InitTBDFood());
}

class InitTBDFood extends StatelessWidget {
  // init user
  // check if user is a new user, if they are a new user, perform first time setup. 
  //
  //if the user is not a new user, then load up the users data as a User object. 
  // user.loadUserDate(); <-- future function
  final User myUser = User(age: 25, activityLevel: 30, hasWeightGoals: false, vegan: false, vegetarian: false, glutenIntolerant: false);
  

  late BarcodeScannerSimple barcodeScannerSimple = BarcodeScannerSimple(user: myUser, timeout: 10);
  

  InitTBDFood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Display the barcode scanner widget
            barcodeScannerSimple,
          ],
        ),
      ),
    );
  }
}