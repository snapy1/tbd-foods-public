import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tbd_foods/api_handling/api_handler.dart';
import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/materials/inner_glow.dart';
import 'package:tbd_foods/materials/more_information.dart';
import 'package:tbd_foods/user_management/user.dart';
// import 'package:inner_glow/inner_glow.dart';

/// ***** in the future add local storage that keeps track of the previous bar codes scanned and their associated prompt for the user and that particular food/barcode ******

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
  // late ServerConnection server = ServerConnection(IP: "http://192.168.50.227:5001");
  late ApiHandler handler = const ApiHandler(key: "16BafyUODec4VGJxA");
  double lastScore = 0;
  Color currentColor = Colors.transparent;

  // Initialize the customGlow in initState with dummy values
  late CustomInnerGlow customGlow;
   // Controls visibility of the MoreInformation widget
  bool _isMoreInfoVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize with placeholder width and height
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

  /// Handles the barcode processing and request to the server 
  /// (in the future it will handle the swift and kotlin channels instead of a server request).
  /// then updates our border with a color representing the number. 
  /// 

  void _handleBarcode(BarcodeCapture barcodes) async {
  if (!mounted) return;

  setState(() {
    _currentBarcode = barcodes.barcodes.firstOrNull;
  });

  // Ensure the barcode has a display value and is different from the previous one
  if (_currentBarcode != null && _currentBarcode!.displayValue != null) {
    if (_prevBarcode != _currentBarcode!.displayValue) {
      _prevBarcode = _currentBarcode!.displayValue; // Update the previous barcode
      print('Scanned barcode: ${_currentBarcode!.displayValue}');

      try {
        // Optional: Show a loading indicator or glow effect here

        // Send the request to the Flask server and await the response
        final Map<String, dynamic> response = await handler.sendChompRequest(
          widget.user,
          _currentBarcode!.displayValue,
        );

        // Process the data into a new Food object
        Food foodObject = Food(response, widget.user);

        // Perform further actions with the Food object (e.g., update UI or state)
        print('Processed response: $response');
      } catch (e) {
        // Handle errors gracefully
        print('Error during barcode handling: $e');
      }
    }
  }
}

//   void _handleBarcode(BarcodeCapture barcodes) {
//   if (mounted) {
//     setState(() {
//       _currentBarcode = barcodes.barcodes.firstOrNull;

//       // Print the barcode number to the console
//       if (_currentBarcode != null && _currentBarcode!.displayValue != null) {

//         // If the bar code is different than the previous one, then go ahead and process it.
//         if (_prevBarcode != _currentBarcode!.displayValue) {
//           print('Scanned barcode: ${_currentBarcode!.displayValue}');

//           // Send to Flask server.
//           // Make the server request async and await the result
          
//           /// [Future Addition]
//           // While we are waiting for the request, lets go ahead give the glow
//           // a little effect while we are waiting for the results. 

//           // [updated method of api calls to work across all platforms without the need for channels]

//           // Request and recieve JSON data from the API. 
//           Future<Map<String, dynamic>> call = handler.sendChompRequest(widget.user, _currentBarcode!.displayValue);
          
//           // Process the data into a new food object
//           Food foodObject = Food(call as Map<String, dynamic>, widget.user);

//           return; // remove then 


// // [Old way]
//   //         server.sendRequest(widget.user, _currentBarcode!.displayValue).then((result) {
//   //           // Handle the result of the request

//   //           // Create our food object after receriving the result
//   //           Food foodObject = Food(result, widget.user);

//   //           // Now we can process the Food object's information with AI
//   //           server.sendInfoToAI(foodObject).then((aiResult) {
              
//   //             foodObject.setAnalysis(aiResult);
//   //             foodObject.setScore(aiResult);
              
//   //             // Update the lastScore and refresh UI
//   //             setState(() {
//   //               // Have the score reflect the color of glow and update it in here
//   //               changeGlowColor(customGlow.getColorForValue(foodObject.getScore()));
//   //               lastScore = foodObject.getScore();
//   //             });

//   //             // Update the glowing stroke/border around the camera. 
//   //             print(foodObject.getAnalysis());
//   //             print("Food score: ${foodObject.getScore()}" );

//   //           }).catchError((error) {
//   //             throw Exception('Error occurred during AI processing: $error');
//   //           });

//   //         }).catchError((error) {
//   //           throw Exception('Error occurred during the request: $error');
//   //         });

// // [end old way]


//           // Start or reset the timer to set prevBarcode to null after X seconds (e.g., 10 seconds)
//           resetTimer?.cancel();  // Cancel any previous timer if it's running
//           resetTimer = Timer(Duration(seconds: widget.timeout), () {
//             setState(() {
//               _prevBarcode = null;
//               print('prevBarcode reset to null after 10 seconds.');
//             });
//           });

//           _prevBarcode = _currentBarcode!.displayValue;
//         }
//       } else {
//         throw Exception('No display value for the scanned barcode.');
//       }
//     });
//   }
// }

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

          // Adding the MoreInformation widget conditionally
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


