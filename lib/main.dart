// ignore_for_file: must_be_immutable
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbd_foods/barcode_managment/barcode_manager.dart';
import 'package:tbd_foods/user_management/init_user.dart';
import 'package:tbd_foods/user_management/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
final String? chompKey = dotenv.env['CHOMPFOODS_API_KEY'];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Loading environmental variables from the root directory
    await dotenv.load(fileName: ".env");

    // Initialize OpenAI
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("OPENAI_API_KEY is missing from the .env file.");
    }
    OpenAI.apiKey = apiKey;
    OpenAI.requestsTimeOut = const Duration(seconds: 30);
    OpenAI.baseUrl = "https://api.openai.com/v1/chat/completions?";
    OpenAI.organization = "org-bSIAB4bYm210wgLzAZxtjumX";

    // Initializing Hive
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    var box = await Hive.openBox('userBox');

    bool isFirstTime = box.get('firstTime', defaultValue: true);
    User? savedUser = box.get('user');

    // Start the application
    runApp(MyApp(isFirstTime: isFirstTime, savedUser: savedUser));
  } catch (e, stackTrace) {
    print("Error during initialization: $e");
    print(stackTrace);

    // Show an error screen or fallback widget
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Initialization failed: $e")))));
  }
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
      home: isFirstTime ? const InitNewUser() : (savedUser != null ? InitTBDFood(myUser: savedUser!) : const InitNewUser()), // Fallback to InitNewUser if savedUser is null
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
                  MaterialPageRoute(builder: (context) => EditExistingUser(existingUser: myUser,)), // Pass the new user to the next screen
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
class InitNewUser extends StatelessWidget {
  const InitNewUser({super.key,});

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


/// This class is nearly identical to the InitNewUser class, but it is 
/// used for just modifying the users presets when a user is already created
/// in the hive. 
class EditExistingUser extends StatelessWidget {
  final User existingUser;  // Mark final since it’s required and passed in the constructor
  const EditExistingUser({super.key, required this.existingUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editing User Info')),
      body: InitUser(
        initialUserData: existingUser,  // Pass the existing user data 
        onUserCreated: (updatedUser) async {
          // Open the box and save the updated user information
          var box = await Hive.openBox('userBox');

          box.put('user', updatedUser); // Update with the new user data
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InitTBDFood(myUser: updatedUser)),
          );
        },
      ),
    );
  }
}



