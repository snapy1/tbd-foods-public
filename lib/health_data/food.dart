  /// This class will hold information about a specfic food object. 
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
  final String? foodGroup;
  final bool? isOrganic;
  final String? processingLevel;
  // final DateTime expirationDate;

  Food(
    this.calories,
    this.weightInGrams,
    this.servingSize,
    this.addedSugars,
    this.fiber,
    this.sodium,
    this.saturatedFats,
    this.transFats,
    this.vitamins,
    this.protein,
    this.carbohydrates,
    this.totalFats,
    this.cholesterol,
    this.naturalSugars,
    this.glycemicIndex,
    this.allergens,
    this.foodGroup,
    this.isOrganic,
    this.processingLevel,
    // this.expirationDate,
  );




}