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
  final bool vegan;
  final bool vegetarian;
  final bool glutenIntolerant;
  final int? currentWeight;
  final int? weightGoal;
  final String? religion;
  final List<String>? chronicConditions;
  final List<String>? nutrientDeciencies;
  final List<String>? restrictions;

  User(
    {
      required this.age,
      required this.activityLevel,
      required this.hasWeightGoals, 
      required this.vegan,
      required this.vegetarian,
      required this.glutenIntolerant,
      this.currentWeight,
      this.weightGoal,
      this.religion,
      this.chronicConditions,
      this.nutrientDeciencies,
      this.restrictions
    }
  );

  Map<String, dynamic>? getAllInformation(){
    return {
      'age': age,
      'activity level': 'User as an activity level of $activityLevel which is measured from a range of 0-10',
      'weight goals': hasWeightGoals ? weightGoal : 'User has no weight goal.',
      'religion': religion==null ? 'User has no religous based preferences' : 'User is following the the religion of $religion''s',
      'chronic conditions': _chronicConditionsToString() ?? 'User has no chronic conditions',
      'nutrient deficiencies': _nutrientDeficienciesToString() ?? 'User has no nutrient defciencies',
      'other restrictions': _otherRestrictionsToString() ?? 'User has no other restrictions'
    };
  }

  // Function to format the chronic conditions list. and return it in a s, s, s, s format. 
  String? _otherRestrictionsToString() {
    if (restrictions == null) return null;

    // Join all allergens with a comma separator
    return '${restrictions?.join(', ')},';
  }

  // Function to format the netrient deficiencies list. and return it in a s, s, s, s format. 
  String? _nutrientDeficienciesToString() {
    if (nutrientDeciencies == null) return null;

    // Join all allergens with a comma separator
    return '${nutrientDeciencies?.join(', ')},';
  }

  // Function to format the chronic condiitons list. and return it in a s, s, s, s format. 
  String? _chronicConditionsToString() {
    if (chronicConditions == null) return null;

    // Join all allergens with a comma separator
    return '${chronicConditions?.join(', ')},';
  }

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
    if (restrictions == null) {
      return null; // or return an empty string???: ''
    } else {

        String returnable = "";
        for (int i = 0; i < restrictions!.length; i++) {
          returnable += restrictions![i];
          if (i < restrictions!.length - 1) {
            returnable += ", ";
          }
        }

        return returnable;
    }
  }
  

}