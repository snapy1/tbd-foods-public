/// Will take in information from the user that will be saved on the device. 
/// This information will consist of various factors that are important in keeping
/// track of whether a food is healthy for a user or not. 
/// e.g. Age, Activity Level, Weight Goals, 
/// Chronic conditions (Diabetes, Hypertension, Heart disease, kidney disease),
/// Any food allergies, nuts, gluten (celiac disease), dairy, eggs, etc...,
/// Nutrient deficiencies; helping a user get more nutrients they need,
/// Portion control,
/// Dietary Preferences, vegan, vegetarian, etc. 
/// Religion, e.g. fasting for lent. 
/// and any other specfic dietary restrictions. 
library;


class User {
  final int age;
  final int activityLevel;
  final bool hasWeightGoals;
  final int? currentWeight;
  final int? weightGoal;
  final String? religion;
  final List<String>? chronicConditions;
  final List<String>? nutrientDeciencies;
  final String? dietaryPreferences;
  final List<String>? otherRestrictions;


  User(
    {
      required this.age,
      required this.activityLevel,
      required this.hasWeightGoals, 
      this.currentWeight,
      this.weightGoal,
      this.religion,
      this.chronicConditions,
      this.nutrientDeciencies,
      this.dietaryPreferences,
      this.otherRestrictions
    }
  );

  List<dynamic>? getAllInformation(){
    return [age, activityLevel, hasWeightGoals, currentWeight, weightGoal, religion, chronicConditions, nutrientDeciencies, dietaryPreferences, otherRestrictions];
    
  }

  String? getChronicConditions() {
    if (this.chronicConditions == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < this.chronicConditions!.length; i++) {
          returnable += this.chronicConditions![i];
          if (i < this.chronicConditions!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }

  String? getNutrientDeciencies() {
    if (this.nutrientDeciencies == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < this.nutrientDeciencies!.length; i++) {
          returnable += this.nutrientDeciencies![i];
          if (i < this.nutrientDeciencies!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }

  String? getOtherRestrictions() {
    if (this.otherRestrictions == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < this.otherRestrictions!.length; i++) {
          returnable += this.otherRestrictions![i];
          if (i < this.otherRestrictions!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }
  

}