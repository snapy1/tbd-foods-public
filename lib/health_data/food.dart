
import 'package:tbd_foods/user_management/user.dart';

/// This class will hold information about a specific food object.
class Food {
  final User user;
  final Map<String, dynamic> jsonData;
  double score;
  String? analysis;
  double? calories;
  dynamic servingSize;
  double? addedSugars;
  double? fiber;
  double? sodium;
  double? saturatedFats;
  double? transFats;
  Map<String, int>? vitamins;
  double? protein;
  double? carbohydrates;
  double? totalFats;
  double? cholesterol;
  double? naturalSugars;
  double? calcium;
  double? iron;
  double? vitaminC;
  double? vitaminA;
  double? glycemicIndex; // Good for determining food health for diabetics.
  List<String>? allergens;
  List<String>? ingredients;
  String? foodGroup;
  bool? isOrganic;
  String? processingLevel;
  String? description;

  // Updated constructor to initialize fields directly from a parsed Map.
   // Constructor to initialize fields
  Food(this.jsonData, this.user)
      : naturalSugars = null, // Not provided in the example JSON
        glycemicIndex = null, // Not provided in the example JSON
        processingLevel = 'Low', // Default assumption; could be adjusted dynamically
        score = 0,
        analysis = null,
        calories = null,
        protein = null,
        totalFats = null,
        carbohydrates = null,
        fiber = null,
        addedSugars = null,
        sodium = null,
        saturatedFats = null,
        transFats = null,
        cholesterol = null,
        vitamins = null,
        servingSize = null,
        allergens = null,
        ingredients = null,
        foodGroup = null,
        isOrganic = null,
        description = null,
        calcium = null,
        iron = null,
        vitaminC = null,
        vitaminA = null
        {
    // Now assign the values inside the constructor body

    // Helper function to get nutrient value by name
    double? getNutrientValue(String nutrientName) {
      for (var nutrient in jsonData['items'][0]['nutrients']) {
        if (nutrient['name'].toString().toLowerCase() == nutrientName.toLowerCase()) {
          return nutrient['per_100g'];
        }
      }
      return null;
    }

    // Assign values to fields
    calories = getNutrientValue('Energy');
    protein = getNutrientValue('Protein');
    totalFats = getNutrientValue('Total lipid (fat)');
    carbohydrates = getNutrientValue('Carbohydrate, by difference');
    fiber = getNutrientValue('Fiber, total dietary');
    addedSugars = getNutrientValue('Sugars, total including NLEA');
    calcium = getNutrientValue('Calcium, Ca');
    iron = getNutrientValue('Iron, Fe');
    sodium = getNutrientValue('Sodium, Na');
    vitaminC = getNutrientValue('Vitamin C, total ascorbic acid');
    vitaminA = getNutrientValue('Vitamin A, IU');
    saturatedFats = getNutrientValue('Fatty acids, total saturated');
    transFats = getNutrientValue('Fatty acids, total trans');
    cholesterol = getNutrientValue('Cholesterol');

    servingSize = jsonData['items'][0]['serving']['size'];
    allergens = List<String>.from(jsonData['items'][0]['allergens']);
    ingredients = List<String>.from(jsonData['items'][0]['ingredient_list']);

    if (jsonData['items'][0]['categories'] != null &&
        jsonData['items'][0]['categories'].isNotEmpty) {
      foodGroup = jsonData['items'][0]['categories'][0];
    }

    isOrganic = jsonData['items'][0]['name']
            .toString()
            .toLowerCase()
            .contains('organic') ||
        jsonData['items'][0]['description']
            .toString()
            .toLowerCase()
            .contains('organic');

    description = jsonData['items'][0]['description'];
  }

  void setScore(String response){ 
     // Find the part of the text containing "Score: [integer]"
      RegExp scoreRegex = RegExp(r'Score:\s*(\d+)');
      Match? match = scoreRegex.firstMatch(response);

      // Return the extracted score as an integer if found
      if (match != null) {
        this.score = double.parse(match.group(1)!);
        return;
      }

      // Return exception if no score is found
      throw Exception('Score not found in the response.');
    }

  double getScore() { return this.score; }
  String? getAnalysis() { return this.analysis; }


  void setAnalysis(String input) {
    // Find everything up to the line that contains "Score: [integer]"
    RegExp scoreLineRegex = RegExp(r'Score:\s*\d+');
    List<String> lines = input.split('\n');

    // Loop through lines and collect them until the "Score" line is reached
    List<String> analysisLines = [];
    for (String line in lines) {
      if (scoreLineRegex.hasMatch(line)) {
        break;  // Stop when the "Score" line is found
      }
      analysisLines.add(line);
    }
    this.analysis = analysisLines.join('\n').trim();
  }
  
  // Helper method to format all food information in a Map.
  Map<String, dynamic> getAllInformation() {
    return {
      'calories': calories != null 
          ? '$calories number of calories per 100 grams' 
          : 'No total calorie information available.',

      'serving size': servingSize ?? 'No serving size information available.',
      'added sugars': addedSugars ?? 'No added sugar information available.',
      'fiber': fiber ?? 'No fiber information available.',
      'sodium': sodium ?? 'No sodium information available.',
      'saturated fats': saturatedFats ?? 'No saturated fat information available.',
      'trans fats': transFats ?? 'No trans fat information available.',
      'vitamins': _vitaminsToString() ?? 'No vitamin information available.',
      'protein': protein ?? 'No protein information available.',
      'carbohydrates': carbohydrates ?? 'No carbohydrate information available.',
      'total fats': totalFats ?? 'No fat information available.',
      'cholesterol': cholesterol ?? 'No cholesterol information available.',
      'natural sugars': naturalSugars ?? 'No natural sugar information available.',
      'glycemic index': glycemicIndex ?? 'No glycemic index information available.',
      'allergens': _allergensToString() ?? 'No allergen information available.',
      'ingredients': _ingredientsToString() ?? 'No ingredient information available.',
      'food group': foodGroup ?? 'No food group information available.',
      'isOrganic': isOrganic ?? 'No organic information available.',
      'processing level': processingLevel ?? 'No processing level information available.',
    };
  }

  /// First it will check and see if the user is vegan, or vegetarian,
  /// requiring a gluten free diet. 
  /// 
  /// If they do require any of the following restrictions to be followed,
  /// it will then check the food and see if the food matches that description or not. 
  /// If it does not (if the food is incompatible) then return false. 
  /// 
  /// If it passed that first check, then it will search through the foods ingredients and
  /// the users dietaryRestrictions and see if any incompatible ingredients are found.
  /// If any restrictions are matched immediently return false. 
  /// 
  /// Otherwise, no restrictions are matched so return true.
  /// 
  bool dietaryIncompadibilityCheck(){
    if (user.vegan){
      if (dietCompatibility("vegan") == false) return false;
    }

    if (user.vegetarian){
      if (dietCompatibility("vegetarian") == false) return false;
    }

    if (user.glutenIntolerant){
      if (dietCompatibility("glutenIntolerant") == false) return false;
    }

    // passed quick ez checks
    // so lets move onto the big check.

    if (user.restrictions != null){ // if the user has not supplied any restrictions, then just skip past this. 
      dynamic ingredients = getIngredient();

      // if the ingredients return as a String, then we need to put it into a list for iteration.
      // using a comma as the delimiter in the String for the ingredients. 
      if (ingredients is String){

          // Step 1: Remove periods from the string
        ingredients = ingredients.replaceAll('.', '');

        // Step 2: Split the string by commas while keeping everything in between commas together
        List<String> ingredientList = ingredients.split(',').map((item) => item.trim()).toList();

        // since ingredients is dynamic, we can just assign it back to ingredients then we 
        // have made our array a List<String>. 
        ingredients = ingredientList;
      }

      // otherwise it must be a list so lets just conintue normally. 

      // looping through all of the restrictions and ingredients to see if any of them match. 
      for (var restriction in user.restrictions!){
        for (var ingredient in ingredients){
          if (restriction == ingredient) return false;
        }
      }

    }
    // if there are no matches then we must be good, so return true. 
    return true;
  }


  /// Diet label can be "gluten_free", "vegan", or "vegetarian". 
  /// Returns true, false, or null depending on how compadible it is. 
  /// 'true' for fully compatible. 'false' for not compatible. 'null' for compatibility unknown.
  /// Otherwise null (if there is an issue pulling data or something).
  bool? dietCompatibility(String dietLabel){
    if (jsonData['items'][0]['diet_labels'][dietLabel]['is_compatible'] == true) return true;
    if (jsonData['items'][0]['diet_labels'][dietLabel]['is_compatible'] == false) return true;
    if (jsonData['items'][0]['diet_labels'][dietLabel]['is_compatible'] == null) return null;
    return null;
  }

  /// Returns the name and the brand of the product. 
  /// Only returns it if either @name or @brand are null. 
  String? getName(){
    String? brand = jsonData['items'][0]["brand"];
    String? name = jsonData['items'][0]["name"];
    return (brand != null && name != null) ? "$brand: $name" : null;
  }

  /// Returns the ingredients if they are not null. 
  /// If they are null it will try to return the ingredients_list instead
  /// which is the same thing, just in a listed format.
  /// If both are null, then just return null.   
  dynamic getIngredient() {
    if (jsonData['items'][0]['ingredients'] != null){
      return jsonData['items'][0]['ingredients'];
    } 
    if (jsonData['items'][0]['ingredients_list'] != null){
      return jsonData['items'][0]['ingredients_list'];
    }
    return null;
  }

  List<String>? getAllNutrients() {
    List<String> returnable = [];
    // Check if 'items' and 'nutrients' exist and are in the expected format
    if (jsonData['items'] != null && jsonData['items'] is List && jsonData['items'][0]['nutrients'] != null) {
      // Iterate over the nutrients
      for (final nutrient in jsonData['items'][0]['nutrients']) {
        // Extract the name, measurement unit, and amount per 100g
        String? name = nutrient['name'];
        String? measurementType = nutrient['measurement_unit'];
        dynamic per100g = nutrient['per_100g'];  // Using dynamic in case per_100g is not a String or int

        // Add the nutrient details
        returnable.add(
          'Nutrient name: ${name == null ? name : 'Name not specified.'}, '
          'Nutrient measurement unit: ${measurementType == null ? measurementType : 'Units not specified.'}, '
          'Amount of $measurementType per 100g: ${per100g == null ? per100g : 'Ammount of $measurementType not specified.'}'
        );

      }
      return returnable;
    } else {
      print("Invalid JSON structure: 'items' or 'nutrients' not found.");
      return null;
    }
  }

  String parseForAIInterpretation(){
    return 
    "Take the following information about the users health and dietary information. "
    "Then take all of following information about this specific food"
    " and return a score from 0 to 100 based on how healthy the food is for the user based"
    " off of their health information that I have provided and the various food specifications/information."
    ""
    "Here is all of the users health information:"
    "${user.getAllInformation()}"
    "\n"
    "Here is the food information: "
    "Food name: ${getName()}"
    "Food nutrients: "
    "${getAllNutrients()}"
    "\n"
    "Food ingredients: "
    "${getIngredient()}"
    "\n"
    ""
    "Allergens: $allergens"
    ""
    "At the end of your prompt, please response with the score"
    "in the following format and nothing else at the end."
    "Score: [score]";

  }

    // Helper function to format allergens.
    String? _allergensToString() {
      return allergens?.join(', ');
    }

    // Helper function to format ingredients.
    String? _ingredientsToString() {
      return ingredients?.join(', ');
    }

    // Helper function to format vitamins.
    String? _vitaminsToString() {
      if (vitamins == null) return null;
      return vitamins!.entries.map((entry) => '${entry.key}: ${entry.value}%').join(', ');
    }

}