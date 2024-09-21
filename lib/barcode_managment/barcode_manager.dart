import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tbd_foods/barcode_managment/json_parser.dart';
import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/server_connection/server_connection.dart';
import 'package:tbd_foods/user_management/user.dart';

class BarcodeScannerSimple extends StatefulWidget {
  final int timeout; // timeout in seconds for barcode duplication
  final User user;

  const BarcodeScannerSimple({super.key, required this.timeout, required this.user});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _currentBarcode;
  String? _prevBarcode;
  Timer? resetTimer;  //Timer to reset prevBarcode
  JsonParser parser = JsonParser();
  late ServerConnection server = ServerConnection(IP: "http://192.168.50.227:5001");
  

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }



  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _currentBarcode = barcodes.barcodes.firstOrNull;

        // Print the barcode number to the console
        if (_currentBarcode != null && _currentBarcode!.displayValue != null) {

          // If the bar code is different than the previous one, then go ahead and process it.
          // This eliminates multiple API calls of the same barcode.
          if (_prevBarcode != _currentBarcode!.displayValue) {
            print('Scanned barcode: ${_currentBarcode!.displayValue}');

            // creating our Food object first.
            Food? foodObject;

            // Send to Flask server.
            // Make the server request async and await the result
            server.sendRequest(widget.user, _currentBarcode!.displayValue).then((result) {
              // Handle the result of the request
              print('Request result: $result');

              // Assign our food object
              foodObject = Food(result, widget.user);


            }).catchError((error) {
              print('Error occurred during the request: $error');
            });

            // now we can process the Food objects information with AI 

            

            // Start or reset the timer to set prevBarcode to null after X seconds (e.g., 10 seconds)
            resetTimer?.cancel();  // Cancel any previous timer if it's running
            resetTimer = Timer(Duration(seconds: widget.timeout), () {
              setState(() {
                _prevBarcode = null;
                print('prevBarcode reset to null after 10 seconds.');
              });
            });

            _prevBarcode = _currentBarcode!.displayValue;
          }
        } else {
          print('No display value for the scanned barcode.');
        }
      });
    }
  }

  Future<void> startScanning() async {
    // Add logic here if needed when scanning is started
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_currentBarcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}


