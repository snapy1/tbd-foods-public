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
/// 
library;


import 'package:hive/hive.dart';
import 'package:tbd_foods/user_management/measurement_util.dart';
// import 'lib.g.dart';

// Don't forget to add this annotation for the adapter
part 'user.g.dart';

@HiveType(typeId: 0)
class User {

  @HiveField(0)
  final int? age;

  @HiveField(1)
  final int? activityLevel;

  @HiveField(2)
  final bool hasWeightGoals;

  @HiveField(3)
  final bool vegan;

  @HiveField(4)
  final bool vegetarian;

  @HiveField(5)
  final bool glutenIntolerant;

  @HiveField(6)
  final int? currentWeight;

  @HiveField(7)
  final int? weightGoal;

  @HiveField(8)
  final String? religion;

  @HiveField(9)
  final List<String>? chronicConditions;

  @HiveField(10)
  final List<String>? nutrientDeciencies;

  @HiveField(11)
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

  /// [Don't modify the key names] because they are used in the food class
  /// for the @parseForAIInterpretation() function. 
  Map<String, dynamic>? getAllInformation(){
    String unit = MeasurementUtil.getMeasurementUnit();
    return {
      'age': age,
      'activity level': activityLevel != null ? 'User as an activity level of $activityLevel which is measured from a range of 0-10\n': 'User has not specified an activity level',
      'current weight': hasWeightGoals ? '$currentWeight$unit' : 'User has no weight goal so this can be ignored.\n',
      'weight goal': hasWeightGoals ? '$weightGoal$unit' : 'User has no weight goal so this can be ignored.\n',
      'religion': (religion==null || religion == "") ? 'User has no religous based preferences' : 'User is following the the religion of $religion\n',
      'chronic conditions': _chronicConditionsToString(),
      'nutrient deficiencies': _nutrientDeficienciesToString(),
      'other restrictions': _otherRestrictionsToString()
    };
  }

  // Function to format the chronic conditions list. and return it in a s, s, s, s format. 
  // Function to handle chronic conditions
    String _chronicConditionsToString() {
      if (chronicConditions == null || chronicConditions!.isEmpty) {
        return 'User has no chronic condition(s)';
      }
      // Join the chronic conditions with a comma if the list has values
      return chronicConditions!.join(', ');
    }

    // Function to handle nutrient deficiencies
    String _nutrientDeficienciesToString() {
      if (nutrientDeciencies == null || nutrientDeciencies!.isEmpty) {
        return 'User has no nutrient deficiency(ies)';
      }
      // Join the nutrient deficiencies with a comma if the list has values
      return nutrientDeciencies!.join(', ');
    }

    // Function to handle other restrictions
    String _otherRestrictionsToString() {
      if (restrictions == null || restrictions!.isEmpty) {
        return 'User has no other restriction(s)';
      }
      // Join the restrictions with a comma if the list has values
      return restrictions!.join(', ');
    }

  /// If @chronicConditions is not null, 
  /// then it will return it as one big long string. 
  /// 
  /// Otherwise, just returns null. 
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

  /// If @nutrientDeciencies is not null, 
  /// then it will return it as one big long string. 
  /// 
  /// Otherwise, just returns null. 
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

  /// If @restrictions is not null, 
  /// then it will return it as one big long string. 
  /// 
  /// Otherwise, just returns null. 
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