// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbd_foods/barcode_managment/barcode_manager.dart';
import 'package:tbd_foods/user_management/init_user.dart';
import 'package:tbd_foods/user_management/user.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive

  // Register the UserAdapter
  Hive.registerAdapter(UserAdapter());  

  // Open the Hive box used to store user information
  var box = await Hive.openBox('userBox');

  // Checking to see if the user has used the app before or not. 
  bool isFirstTime = box.get('firstTime', defaultValue: true);
  User? savedUser = box.get('user'); // Try to load the saved User object

  // Finally spin up the application once all the user information is attemped to be loaded. 
  runApp(MyApp(isFirstTime: isFirstTime /*<-- Can be just changed to strictly false or true for debugging if needed. */, savedUser: savedUser));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final User? savedUser;
  const MyApp({super.key, required this.isFirstTime, this.savedUser});

  @override
  Widget build(BuildContext context) {

    /// Checks to see if the user is a new user or not. If they are a new user, then we will need to return the MaterialApp of "InitNewUser()"
    /// in order to initialize the new user. 
    /// 
    /// Otherwise we can just load the primary app "InitTBDFood" and pass the savedUser object that we got from the hive
    /// as its paramter for the constructor. 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstTime ? InitNewUser() : (savedUser != null ? InitTBDFood(myUser: savedUser!) : InitNewUser()), // Fallback to InitNewUser if savedUser is null
    );
  }
}


/// This is our primary application layer
/// where the user will interact with the applications main interface. 
/// 
class InitTBDFood extends StatelessWidget {
  final User myUser;
  late BarcodeScannerSimple barcodeScannerSimple = BarcodeScannerSimple(user: myUser, timeout: 10);

  InitTBDFood({super.key, required this.myUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Display the barcode scanner widget
          barcodeScannerSimple,

          // Positioned settings icon
          Positioned(
            top: 50, // Distance from the top
            right: 10, // Distance from the right
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Switch to InitNewUser with preloaded settings
                print("Settings Icon Pressed");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InitNewUser()), // Pass the new user to the next screen
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// This class/application layer is responsible for initialzing a new user. 
/// Once the new user is initialized it will automatically reinstate its self with the 
/// "InitTBDFoods" class/application layer.
/// 
/// [All class comments below are a WIP and will be added/worked on gradually]
/// This can also be used to modify the users settings. 
/// How that works, it will take a user object as a paramter for its constructor. 
/// If that user object is null, then we know it is indeed a brand new user. 
/// 
/// If it is not null, then we know that the user must be there to just modify their defaults, 
/// so then we can go ahead and process the users info and fill it into our boxes with the users info, 
/// so that they do not have to retype everything. 
class InitNewUser extends StatelessWidget {
  const InitNewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Time Setup')),
      body: InitUser(onUserCreated: (User newUser) async {
        // Save the user data to the box and transition to the main app
        var box = await Hive.openBox('userBox');
        box.put('firstTime', false); // Mark first-time as completed
        box.put('user', newUser); // Save user data

        // After setup, transition to the regular app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InitTBDFood(myUser: newUser)), // Pass the new user to the next screen
        );
      }),
    );
  }
}
