import 'dart:convert';

/// This class will hold information about a specific food object.
class Food {
  final int? calories;
  final int? weightInGrams;
  final int? servingSize;
  final int? addedSugars;
  final int? fiber;
  final int? sodium;
  final int? saturatedFats;
  final int? transFats;
  final Map<String, int>? vitamins;
  final int? protein;
  final int? carbohydrates;
  final int? totalFats;
  final int? cholesterol;
  final int? naturalSugars;
  final int? glycemicIndex; // Good for determining food health for diabetics.
  final List<String>? allergens;
  final List<String>? ingredients;
  final String? foodGroup;
  final bool? isOrganic;
  final String? processingLevel;

  // Updated constructor to initialize fields directly from JSON.
  Food(String jsonData)
      : calories = _parseNutrientValue(jsonData, 'Energy'),
        protein = _parseNutrientValue(jsonData, 'Protein'),
        totalFats = _parseNutrientValue(jsonData, 'Total lipid (fat)'),
        carbohydrates = _parseNutrientValue(jsonData, 'Carbohydrate, by difference'),
        fiber = _parseNutrientValue(jsonData, 'Fiber, total dietary'),
        addedSugars = _parseNutrientValue(jsonData, 'Sugars, total including NLEA'),
        sodium = _parseNutrientValue(jsonData, 'Sodium, Na'),
        saturatedFats = _parseNutrientValue(jsonData, 'Fatty acids, total saturated'),
        transFats = _parseNutrientValue(jsonData, 'Fatty acids, total trans'),
        cholesterol = _parseNutrientValue(jsonData, 'Cholesterol'),
        naturalSugars = null, // Not provided in the example JSON
        glycemicIndex = null, // Not provided in the example JSON
        vitamins = _parseVitamins(jsonData),
        servingSize = _parseServingSize(jsonData),
        allergens = _parseAllergens(jsonData),
        ingredients = _parseIngredients(jsonData),
        foodGroup = _parseFoodGroup(jsonData),
        isOrganic = _parseIsOrganic(jsonData),
        processingLevel = 'Low', // Default assumption; could be adjusted dynamically
        weightInGrams = 100; // Assuming based on package size

  // Helper method to extract nutrient values from the JSON data.
  static int? _parseNutrientValue(String jsonData, String nutrientName) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    final nutrients = foodItem['nutrients'];

    for (var nutrient in nutrients) {
      if (nutrient['name'] == nutrientName) {
        return nutrient['per_100g'].toInt();
      }
    }
    return null;
  }

  // Helper method to extract vitamins from the JSON data.
  static Map<String, int>? _parseVitamins(String jsonData) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    final nutrients = foodItem['nutrients'];
    Map<String, int> vitamins = {};

    for (var nutrient in nutrients) {
      if (nutrient['name'].contains('Vitamin')) {
        vitamins[nutrient['name']] = nutrient['per_100g'].toInt();
      }
    }
    return vitamins.isNotEmpty ? vitamins : null;
  }

  // Helper method to extract serving size from the JSON data.
  static int? _parseServingSize(String jsonData) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    return foodItem['serving']['size'];
  }

  // Helper method to extract allergens from the JSON data.
  static List<String>? _parseAllergens(String jsonData) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    final allergens = List<String>.from(foodItem['allergens']);
    return allergens.isNotEmpty ? allergens : null;
  }

  // Helper method to extract ingredients from the JSON data.
  static List<String>? _parseIngredients(String jsonData) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    final ingredients = List<String>.from(foodItem['ingredient_list']);
    return ingredients.isNotEmpty ? ingredients : null;
  }

  // Helper method to extract food group from the JSON data.
  static String? _parseFoodGroup(String jsonData) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    return foodItem['categories'] != null && foodItem['categories'].isNotEmpty ? foodItem['categories'][0] : null;
  }

  // Helper method to determine if the food is organic.
  static bool? _parseIsOrganic(String jsonData) {
    final parsedJson = jsonDecode(jsonData);
    final foodItem = parsedJson['items'][0];
    final ingredients = foodItem['ingredient_list'].toString().toLowerCase();
    return ingredients.contains('organic');
  }
}
