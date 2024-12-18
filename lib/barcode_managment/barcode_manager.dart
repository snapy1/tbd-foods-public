import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tbd_foods/api_handling/api_handler.dart';
import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/materials/inner_glow.dart';
import 'package:tbd_foods/materials/more_information.dart';
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
  late ApiHandler handler = const ApiHandler();
  double lastScore = 0;
  Color currentColor = Colors.transparent; // initialized the defalt color to just nothing. 

  // Initialize the customGlow in initState with dummy values
  late CustomInnerGlow customGlow;
   // Controls visibility of the MoreInformation widget
  bool _isMoreInfoVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize with placeholder values
    customGlow = CustomInnerGlow(
      height: 0,
      width: 0,
      glowRadius: 20,
      glowBlur: 20,
      thickness: 40,
      currentColor: Colors.transparent, // Default/initial color is just transparency.  
    );
  }

  /// Just our temporary box at the bottom of screen, 
  /// mainly for debugging purposes. Will be removed or upgraded eventually (probably removed).
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

// Handles the barcode scanning by taking the barcode, sending it to our API
// and then creating a food object. 
void _handleBarcode(BarcodeCapture barcodes) async {
  if (!mounted) return;

  setState(() {
    _currentBarcode = barcodes.barcodes.firstOrNull;

    // Check if barcode or displayValue is null
    if (_currentBarcode == null || _currentBarcode!.displayValue == null) {
      throw Exception('No display value for the scanned barcode!');
    }

    // Check if we've scanned the same barcode again
    if (_prevBarcode == _currentBarcode!.displayValue) {
      print('Same barcode scanned again, ignoring this scan.');
      return;
    }

    // This is a new barcode, handle it
    // print('Scanned Barcode: ${_currentBarcode!.displayValue}');

    handler.sendChompRequest(widget.user, _currentBarcode!.displayValue!).then((result) {
      Food foodObject = Food(result, widget.user);

      handler.sendAIRequest(foodObject).then((score) {
        foodObject.setAnalysis(score);
        foodObject.setScore(score);
        print(foodObject.getAllInformation());

        // Update the UI with the new score and glow color
        setState(() {
          changeGlowColor(customGlow.getColorForValue(foodObject.getScore()));
          lastScore = foodObject.getScore();
        });

        // print(foodObject.getAnalysis());
        // print("Food Score: ${foodObject.getScore()}");

      }).catchError((error) {
        throw Exception('Error occurred during the AI request: $error');
      });

    }).catchError((error) {
      throw Exception('Error occurred during the chomp request: $error');
    });

    // Reset the barcode after a certain time
    resetTimer?.cancel();
    resetTimer = Timer(Duration(seconds: widget.timeout), () {
      setState(() {
        _prevBarcode = null;
        // print('prevBarcode set to null after ${widget.timeout} seconds');
      });
    });

    // Update the last scanned barcode
    _prevBarcode = _currentBarcode!.displayValue;
  });
}


  /// Dead function for now -- will update in future if needed, but good to have. 
  Future<void> startScanning() async {
    // Add logic here if needed when scanning is started
    setState(() {});
  }

  /// Function to update the glow color from outside build method
  void changeGlowColor(Color newColor) {
    setState(() {
      customGlow.updateColor(newColor);
    });
  }

  void _toggleMoreInfoVisibility() {
    setState(() {
      _isMoreInfoVisible = !_isMoreInfoVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and update the dimensions in the customGlow
    final screenSize = MediaQuery.of(context).size;
    customGlow.width = screenSize.width;
    customGlow.height = screenSize.height;
    return Scaffold(
      // appBar: AppBar(title:  Text('Current Food Score: $lastScore')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          
          MobileScanner(
            onDetect: _handleBarcode,
          ),

          customGlow.buildGlowingBorder(context),

          // Adding the MoreInformation widget 
          if (_isMoreInfoVisible)
            Center(
              child: MoreInformation(
                user: widget.user,
                // server: server,
                server: null,
                food: null,
                onClose: _toggleMoreInfoVisibility,
              ),
            ),
          // Add button to open MoreInformation
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleMoreInfoVisibility,
              child: const Icon(Icons.info),
            ),
          ),

          if (widget.user.debugMode)
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


