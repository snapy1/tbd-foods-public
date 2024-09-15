import 'dart:async';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSimple extends StatefulWidget {
  final String serverURL; // the IP of the flask server to piggyback API calls. 
  final int timeout; // timeout in seconds for barcode duplication

  const BarcodeScannerSimple({super.key, required this.serverURL, required this.timeout});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _currentBarcode;
  String? _prevBarcode;
  Timer? resetTimer;  //Timer to reset prevBarcode

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
          // this eliminates multiple api calls of the same bar code. 
          // 
          // In the future add a timeout so that this gets reset after X amount 
          // of seconds incase the user wants to scan the same thing twice. 
          if (_prevBarcode != _currentBarcode!.displayValue){
            print('Scanned barcode: ${_currentBarcode!.displayValue}');

            // Send to Flask server. 
            sendFoodDataRequest(_currentBarcode!.displayValue);

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


  // Future function to send a practice request and print JSON response
  Future<void> sendFoodDataRequest(String? idOfFood) async {
    // http://192.168.0.10:5001/get_food_data
    final url = Uri.parse(widget.serverURL);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'food_id': idOfFood}),
    );

    print("Barcode captured: $idOfFood");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Response data: $jsonResponse');
    } else {
      print('Failed to get food data. Status code: ${response.statusCode}');
    }
  }

}


