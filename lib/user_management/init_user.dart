
import 'package:flutter/material.dart';
import 'package:tbd_foods/user_management/measurement_util.dart';
import 'package:tbd_foods/user_management/user.dart';


class InitUser extends StatefulWidget {
  final Function(User) onUserCreated;

  const InitUser({super.key, required this.onUserCreated});

  @override
  _InitUserState createState() => _InitUserState();
}

/// Used to initialize a new user. 

/// Additionally, this class handles all of the widgets that we will see inside of our InitNewUser class application layer. 
class _InitUserState extends State<InitUser> {
  // Form field controllers
  int? _age;
  int? _activityLevel;
  bool _hasWeightGoals = false;
  bool _vegan = false;
  bool _vegetarian = false;
  bool _glutenIntolerant = false;
  int? _currentWeight;
  int? _weightGoal;
  String? _religion;
  User? user;

  // List of controllers for input fields
  List<TextEditingController> controllers = List.generate(3, (_) => TextEditingController());

  final _formKey = GlobalKey<FormState>();

  /// Seperates a string of any size by each comma
  /// and returns a list using the comma as a delimiter. 
  /// e.g. string = "a large dog, a big house, a tiny mouse"
  /// = {a large dog, a big house, a tiny mouse}
  List<String>? getCommaSeparatedValues(String inputText) {
    if (inputText.isEmpty) return null;
    // Split the input text by commas and remove any extra spaces
    return inputText.split(',').map((str) => str.trim()).toList();
  }

  /// Simply handles the box for taking in a string. 
  Widget multipleStringBox(String textBoxText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: textBoxText,
      ),
    );
  }
  
  

  @override
  Widget build(BuildContext context) {
    String unit = MeasurementUtil.getMeasurementUnitFromContext(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            
            // age
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  int? parsedAge = int.tryParse(value);
                  if (parsedAge != null) {
                    setState(() => _age = parsedAge);
                  } else {
                    // Handle invalid input (this should ideally not happen due to validation)
                    setState(() => _age = null);
                  }
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your age';
                if (int.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              },
            ),

            // Activity Level Input
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Activity Level from 1 to 10'),
              value: _activityLevel,
              items: List.generate(10, (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('Level ${index + 1}'),
              )),
              onChanged: (value) => setState(() => _activityLevel = value),
            ),

            // Weight Goal Checkbox
            CheckboxListTile(
              title: const Text('Do you have weight goals?'),
              value: _hasWeightGoals,
              onChanged: (value) => setState(() => _hasWeightGoals = value!),
            ),

            // Current Weight Input (only if weight goals exist)
            if (_hasWeightGoals)
              TextFormField(
                decoration: InputDecoration(labelText: 'Current Weight ($unit)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => setState(() => _currentWeight = int.tryParse(value!)),
              ),

            // Weight Goal Input (only if weight goals exist)
            if (_hasWeightGoals)
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight Goal ($unit)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => setState(() => _weightGoal = int.tryParse(value!)),
              ),

            // Dietary Preferences Checkboxes
            CheckboxListTile(
              title: const Text('Vegan'),
              value: _vegan,
              onChanged: (value) => setState(() => _vegan = value!),
            ),
            CheckboxListTile(
              title: const Text('Vegetarian'),
              value: _vegetarian,
              onChanged: (value) => setState(() => _vegetarian = value!),
            ),
            CheckboxListTile(
              title: const Text('Gluten Intolerant'),
              value: _glutenIntolerant,
              onChanged: (value) => setState(() => _glutenIntolerant = value!),
            ),

            // Religion Input
            TextFormField(
              decoration: const InputDecoration(labelText: 'Religion (optional)'),
              onSaved: (value) => setState(() => _religion = value),
            ),

            // Chronic Conditions Multi-Select
            const Text('Any Chronic Conditions?'),
            Wrap(
              children: [
                multipleStringBox("Separate each by comma, leave blank for none.", controllers[0]),
              ],
            ),

            const Text('Any Nutrient Deficiencies?'),
            Wrap(
              children: [
                multipleStringBox("Separate each by comma, leave blank for none.", controllers[1]),
              ],
            ),

            const Text('Any Dietary Restrictions?'),
            Wrap(
              children: [
                multipleStringBox("Separate each by comma, leave blank for none.", controllers[2]),
              ],
            ),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Create the user instance and pass it back
                  User newUser = User(
                    age: _age,
                    activityLevel: _activityLevel,
                    hasWeightGoals: _hasWeightGoals,
                    vegan: _vegan,
                    vegetarian: _vegetarian,
                    glutenIntolerant: _glutenIntolerant,
                    currentWeight: _currentWeight,
                    weightGoal: _weightGoal,
                    religion: _religion,
                    chronicConditions: getCommaSeparatedValues(controllers[0].text),
                    nutrientDeciencies: getCommaSeparatedValues(controllers[1].text),
                    restrictions: getCommaSeparatedValues(controllers[2].text),
                  );

                  // print for testing
                  print(newUser.getAllInformation());

                  // Call the callback to pass the user back to the main app
                  widget.onUserCreated(newUser);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
