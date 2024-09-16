class JsonParser {

  void parseFoodJson(Map<String, dynamic> jsonData) {
    // Access the items list
    final items = jsonData['items'] as List<dynamic>;

    for (var item in items) {
      // Access and organize the fields into appropriate data types

      String name = item['name'] ?? 'Unknown';
      String description = item['description'] ?? 'No description available';
      String barcode = item['barcode'] ?? 'No barcode available';
      String brand = item['brand'] ?? 'Unknown brand';

      List<String> brandList = List<String>.from(item['brand_list'] ?? []);
      List<String> categories = List<String>.from(item['categories'] ?? []);
      List<String> countries = List<String>.from(item['countries'] ?? []);
      List<String> ingredients = List<String>.from(item['ingredient_list'] ?? []);
      List<String> keywords = List<String>.from(item['keywords'] ?? []);

      // Safely handle null values for boolean fields
      bool hasEnglishIngredients = item['has_english_ingredients'] ?? false;

      Map<String, dynamic> dietLabels = item['diet_labels'] ?? {};
      List<Map<String, dynamic>> nutrients = List<Map<String, dynamic>>.from(item['nutrients'] ?? []);

      Map<String, dynamic> packageInfo = item['package'] ?? {};
      String packageSize = packageInfo['size'] ?? 'Unknown size';

      Map<String, dynamic> packagingPhotos = item['packaging_photos']?['front'] ?? {};
      String photoUrl = packagingPhotos['display'] ?? 'No photo available';

      // Print or return the organized data as needed
      print('Name: $name');
      print('Description: $description');
      print('Barcode: $barcode');
      print('Brand: $brand');
      print('Brand List: ${brandList.join(", ")}');
      print('Categories: ${categories.join(", ")}');
      print('Countries: ${countries.join(", ")}');
      print('Ingredients: ${ingredients.join(", ")}');
      print('Keywords: ${keywords.join(", ")}');
      print('Has English Ingredients: $hasEnglishIngredients');
      print('Package Size: $packageSize');
      print('Photo URL: $photoUrl');
      print('Diet Labels:');

      dietLabels.forEach((key, value) {
        print('- ${value['name']}: ${value['compatibility_level']} (Confidence: ${value['confidence']})');
      });

      print('Nutrients:');
      for (var nutrient in nutrients) {
        print('- ${nutrient['name']} (${nutrient['measurement_unit']}): ${nutrient['per_100g']} per 100g');
      }

      print('--- End of Item ---');
    }
  }
}
