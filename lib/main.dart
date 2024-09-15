import 'package:flutter/material.dart';
import 'package:tbd_foods/barcode_managment/barcode_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitTBDFood());
}

class InitTBDFood extends StatelessWidget {
  final BarcodeScannerSimple barcodeScannerSimple =
      const BarcodeScannerSimple(serverURL: 'http://192.168.0.10:5001/get_food_data', timeout: 10,);

  const InitTBDFood({super.key});

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