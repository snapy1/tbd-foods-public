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

  // can probably remove these single liners in the future since dart allows
  // directly access the objects private variables of the constructor... 
  int getAge(){ return age; }
  int getActivityLevel(){ return activityLevel; }
  int? getCurrentWeight(){ return currentWeight; }
  int? getWeightGoal(){ return hasWeightGoals ? weightGoal : null; }
  String? getReligion(){ return religion; }
  String? getDietaryPreference(){ return dietaryPreferences; }
  ////////////////////////////////////////////////////////////////

  String? getChronicConditions() {
    if (chronicConditions == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < chronicConditions!.length; i++) {
          returnable += chronicConditions![i];
          if (i < chronicConditions!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }

  String? getNutrientDeciencies() {
    if (nutrientDeciencies == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < nutrientDeciencies!.length; i++) {
          returnable += nutrientDeciencies![i];
          if (i < nutrientDeciencies!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }

  String? getOtherRestrictions() {
    if (otherRestrictions == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < otherRestrictions!.length; i++) {
          returnable += otherRestrictions![i];
          if (i < otherRestrictions!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }
  

}