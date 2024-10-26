import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/user_management/user.dart';

/// Will take in a food object as a parameter. This food object will 
/// contain data about the food. Like calories, serving size, ingredients, etc.. 
/// 
/// This call will then give a score in relation to how healthy 
/// the food is considered based off of the users profile.. 
/// The score of the food will be determined by (prone to change) a number between 0 and 100. 
/// ----- Later on we will add a more sophisticated way of calculating whether the food is healthy or not ----
/// ----- For the time being we will use AI to generate this awnser ------------------------------------------
/// 
/// ---- AI Generation will be used for now. -----------------------------------------------------------------
/// Alternatively we can use AI to take in the users information and generate a score
/// between 0 and 100 based off of the foods data, and the users data. 
class CalorieScore {

  final Food currentFood;
  final User currentUser;
  
  CalorieScore({required this.currentFood, required this.currentUser});


  /// Returns a value from 0 to 100 based off of the calorie count. 
  int _calorieScore(int calories) {
    if (calories <= 40) {
      return 0;  // Low-calorie
    } else if (calories <= 200) {
      return 50; // Moderate-calorie
    } else if (calories <= 400) {
      return 75; // High-calorie
    } else {
      return 100; // Very high-calorie
    }
  }




}