// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/user_management/user.dart';

class ServerConnection {

  final String IP;

  // ignore: non_constant_identifier_names
  ServerConnection({required this.IP});

    // A function that will send the bar code to the server, along with the users data. 
    // The server will contact the Chompfoods API running on the piggyback Flask server, finally it will 
    // send the API request to ChompFoods, take that request, parse the JSON on the server. 
    // Send the users data plus the parsed JSON as a request to the OpenAI api. 
    // Get the number (0 - 100) from that request, and finally send it back to the client. 
  Future<dynamic> sendRequest(User userObject, String? barcodeID) async {

    // First this sends the barcode data to our piggy back server,
    final foodURL = Uri.parse('$IP/get_food_data');
    final requestForFoodJSON = await http.post(
      foodURL,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'food_id': barcodeID}),
    );
    
    
    if (requestForFoodJSON.statusCode == 200){ // successful request 
      // print if request was sucessful 
      // print('Response body: ${requestForFoodJSON.body}');
      print(jsonDecode(requestForFoodJSON.body));

     // now create our food object and give it the json response as its parameters
      Food foodObject = (Food(jsonDecode(requestForFoodJSON.body)));
      print("Successfully able to find food object");
    
      // print(foodObject.getAllInformation()); // temp

      // Now assuming everything is good wiht out data, we can make another request to the server, and pass the Food information, 
      // to our AI model. 

      // returning the value from the AI that we get. 
          // return sendInfoToAI(userObject, foodObject); <-- re-enable later
      return  "Request successfully processed";

    } else { // unsuccessful request
    print("Bar code scan unsuccessful");

    // return and handle some sort of error 
    return "-1"; // make integer later 
    }
  }


  Future<dynamic> sendInfoToAI(User user, Food food) async {
    // Combine the information from the user and food into a list of maps
    List<dynamic> JSONAble = [user.getAllInformation(), food.getAllInformation()];

    final url = Uri.parse('$IP/AIHandling');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(JSONAble),  // Encode the list of maps to JSON
    );

    // Check the response and handle errors
    if (response.statusCode == 200) {
      // Extract the integer from the response
      final responseBody = jsonDecode(response.body);
      int result = responseBody['result'];  // Assuming the integer is returned as 'result'
      print('Received integer: $result');
      return result;  // Return the received integer
    } else {
      print('Failed to send request. Status code: ${response.statusCode}');
      return -1;  // Return a failure code
    }
  }

}