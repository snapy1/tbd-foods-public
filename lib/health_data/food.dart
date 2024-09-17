
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

  // Updated constructor to initialize fields directly from a parsed Map.
  Food(Map<String, dynamic> jsonData)
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

  // Helper method to format all food information in a Map.
  Map<String, dynamic> getAllInformation() {
    return {
      'calories': calories ?? 'No total calorie information available.',
      'weight in grams': weightInGrams ?? 'No total weight information available.',
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

  // Helper method to extract nutrient values from the JSON data.
  static int? _parseNutrientValue(Map<String, dynamic> jsonData, String nutrientName) {
    final nutrients = jsonData['nutrients'] as List<dynamic>? ?? [];
    for (var nutrient in nutrients) {
      if (nutrient['name'] == nutrientName) {
        return (nutrient['per_100g'] as num).toInt();
      }
    }
    return null;
  }

  // Helper method to extract vitamins from the JSON data.
  static Map<String, int>? _parseVitamins(Map<String, dynamic> jsonData) {
    final nutrients = jsonData['nutrients'] as List<dynamic>? ?? [];
    final vitamins = <String, int>{};
    for (var nutrient in nutrients) {
      if (nutrient['name'].contains('Vitamin')) {
        vitamins[nutrient['name']] = (nutrient['per_100g'] as num).toInt();
      }
    }
    return vitamins.isNotEmpty ? vitamins : null;
  }

  // Helper method to extract serving size from the JSON data.
  static int? _parseServingSize(Map<String, dynamic> jsonData) {
    return jsonData['serving_size'] as int?;
  }

  // Helper method to extract allergens from the JSON data.
  static List<String>? _parseAllergens(Map<String, dynamic> jsonData) {
    return (jsonData['allergens'] as List<dynamic>?)?.cast<String>();
  }

  // Helper method to extract ingredients from the JSON data.
  static List<String>? _parseIngredients(Map<String, dynamic> jsonData) {
    return (jsonData['ingredient_list'] as List<dynamic>?)?.cast<String>();
  }

  // Helper method to extract food group from the JSON data.
  static String? _parseFoodGroup(Map<String, dynamic> jsonData) {
    final categories = jsonData['categories'] as List<dynamic>? ?? [];
    return categories.isNotEmpty ? categories[0] as String : null;
  }

  // Helper method to determine if the food is organic.
  static bool? _parseIsOrganic(Map<String, dynamic> jsonData) {
    final ingredients = (jsonData['ingredient_list'] as List<dynamic>?)?.join(', ').toLowerCase() ?? '';
    return ingredients.contains('organic');
  }
}