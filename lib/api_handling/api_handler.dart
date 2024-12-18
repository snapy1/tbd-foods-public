import 'dart:async';

import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/user_management/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Handles all API communication to both Chomp & OpenAI. 
class ApiHandler {
  
  const ApiHandler();


  Future<Map<String, dynamic>> sendChompRequest(User userObject, String? barcodeID) async {
    // First, this sends the barcode data to our server
    var url = Uri.parse('https://chompthis.com/api/v2/food/branded/barcode.php?code=$barcodeID&api_key=${dotenv.env['CHOMPFOODS_API_KEY']}');

    try {
      // Send GET request
      final response = await http.get(url);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);
        // print("api_handle.dart response successful");
        return responseData;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }

  Future<String> sendAIRequest(Food food) async {
    String AIMessage = food.parseForAIInterpretation();
    final initRequest = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(AIMessage),
      ],
      role: OpenAIChatMessageRole.user,
    );

    Completer<String> completer = Completer<String>();

    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: [initRequest],
      seed: 423,
      n: 1, // ** Make sure to only request one completion ** 
    );

    StringBuffer buffer = StringBuffer();
    chatStream.listen(
      (streamChatCompletion) {
        final contentItems = streamChatCompletion.choices.first.delta.content;
        if (contentItems != null && contentItems.isNotEmpty) {
          for (var item in contentItems) {
            if (item != null && item.text != '\n') {
              buffer.write(item.text);
            }
          }
        }
      },
      onDone: () {
        // print("Done");
        // print(buffer.toString());
        // Complete the future with the final response
        completer.complete(buffer.toString());
      },
      onError: (error) {
        print("Error: $error");
        completer.completeError(error);
      },
    );

  return completer.future;
  }

}
