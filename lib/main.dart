// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tbd_foods/barcode_managment/barcode_manager.dart';
import 'package:tbd_foods/user_management/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(InitTBDFood());
}

class InitTBDFood extends StatelessWidget {
  final User myUser = User(age: 25, activityLevel: 30, hasWeightGoals: false);
  // user.loadUserDate(); <-- future function

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