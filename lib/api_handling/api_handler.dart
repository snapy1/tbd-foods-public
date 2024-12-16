import 'dart:async';

import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/user_management/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';

class ApiHandler {
  
  final String key; // api key to call, 
  const ApiHandler({required this.key});


  Future<Map<String, dynamic>> sendChompRequest(User userObject, String? barcodeID) async {
    // First, this sends the barcode data to our server
    // https://chompthis.com/api/v2/food/branded/barcode.php?code=031146270606&api_key=16BafyUODec4VGJxA
    var url = Uri.parse('https://chompthis.com/api/v2/food/branded/barcode.php?code=$barcodeID&api_key=$key');

    try {
      // Send GET request
      final response = await http.get(url);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("api_handle.dart response successful");
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
  final init_request = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(AIMessage),
    ],
    role: OpenAIChatMessageRole.user,
  );

  // Create a Completer to await the full streamed response
  Completer<String> completer = Completer<String>();

  final chatStream = OpenAI.instance.chat.createStream(
    model: "gpt-3.5-turbo",
    messages: [init_request],
    seed: 423,
    n: 1, // Make sure to only request one completion
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
      print("Done");
      print(buffer.toString());
      // Complete the future with the final response
      completer.complete(buffer.toString());
    },
    onError: (error) {
      print("Error: $error");
      completer.completeError(error);
    },
  );

  // Await the future that completes when onDone is called.
  return completer.future;
}


  // Future<String> sendAIRequest(Food food) async {
  //   // Combine the information from the user and food into a list of maps

  //   // final url = Uri.parse('/AIHandling');
  //   // final response = await http.post(
  //   //   url,
  //   //   headers: {'Content-Type': 'application/json'},
  //   //   body: jsonEncode(food.parseForAIInterpretation()),  // Encode the list of maps to JSON
  //   // );

  //   String AIMessage = food.parseForAIInterpretation();
  //     final init_request = OpenAIChatCompletionChoiceMessageModel(
  //     content: [
  //       OpenAIChatCompletionChoiceMessageContentItemModel.text(AIMessage),
  //     ],
  //     role: OpenAIChatMessageRole.user,
  //   );

  //   // The request to be sent.
  //   final chatStream = OpenAI.instance.chat.createStream(
  //     model: "gpt-3.5-turbo",
  //     messages: [
  //       init_request,
  //     ],
  //     seed: 423,
  //     n: 1,
  //   );

  // // Listen to the stream back from the AI.
  // StringBuffer buffer = StringBuffer();
  // chatStream.listen(
  //   (streamChatCompletion) {
  //     final contentItems = streamChatCompletion.choices.first.delta.content;

  //     // contentItems should be a list of OpenAIChatCompletionChoiceMessageContentItemModel
  //     if (contentItems != null && contentItems.isNotEmpty) {
  //       for (var item in contentItems) {
  //         if (item != null) {
  //           if (item.text == '\n') continue; // ignore new lines.
  //           // Append only the text field
  //           buffer.write(item.text);
  //         }
  //       }
  //     }
  //   },
  //   onDone: () {
  //     print("Done");
  //     // Print the entire concatenated response
  //     print(buffer.toString());
  //   },
  //   onError: (error) {
  //     print("Error: $error");
  //   },
  // );
  // return buffer.toString();
  // }

}
