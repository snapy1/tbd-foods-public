
import 'package:flutter/material.dart';
import 'package:tbd_foods/user_management/measurement_util.dart';
import 'package:tbd_foods/user_management/user.dart';


class InitUser extends StatefulWidget {
  final User? initialUserData;  // This is the optional initial data
  final Function(User) onUserCreated;

  const InitUser({super.key, required this.onUserCreated, this.initialUserData});

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
  int? _currentWeight;
  int? _weightGoal;
  User? user;

  // List of controllers for the following input fields
  // Chronic Conditions, Nutrient Deficiences, and Other Restrictions
  TextEditingController ageController = TextEditingController();
  ValueNotifier<bool> hasWeightGoals = ValueNotifier<bool>(false); // default value of false
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController weightGoalController = TextEditingController();
  List<TextEditingController> bottomControllers = List.generate(4, (_) => TextEditingController());
  ValueNotifier<bool> debugMode = ValueNotifier<bool>(false); // default value of false
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    if (widget.initialUserData != null) {
      _activityLevel = widget.initialUserData!.activityLevel;
      ageController.text = widget.initialUserData!.age.toString();
      hasWeightGoals.value = widget.initialUserData!.hasWeightGoals; // **Set checkbox based on initial user data**
      currentWeightController.text = widget.initialUserData!.currentWeight?.toString() ?? '';
      weightGoalController.text = widget.initialUserData!.weightGoal?.toString() ?? '';

      bottomControllers[0].text = widget.initialUserData!.getChronicConditions() ?? '';
      bottomControllers[1].text = widget.initialUserData!.getNutrientDeficiencies() ?? '';
      bottomControllers[2].text = widget.initialUserData!.getOtherRestrictions() ?? '';
      bottomControllers[3].text = widget.initialUserData!.getMiscInformation() ?? '';
      debugMode.value = widget.initialUserData!.debugMode; 
    }
  }


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
            
            // Age TextFormField with ageController
            TextFormField(
              controller: ageController,  // Use the ageController here
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                // Parse the value from the ageController text when saving
                int? parsedAge = int.tryParse(ageController.text);
                setState(() {
                  _age = parsedAge ?? null;
                });
              },
              validator: (value) {
                // Validate using the ageController text
                if (ageController.text.isEmpty) return 'Please enter your age';
                if (int.tryParse(ageController.text) == null) return 'Please enter a valid number';
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

            // Checkbox for Weight Goals with ValueListenableBuilder to control visibility
            ValueListenableBuilder<bool>(
              valueListenable: hasWeightGoals,
              builder: (context, hasGoals, child) {
                return Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Do you have weight goals?'),
                      value: hasGoals,
                      onChanged: (value) {
                        if (value != null) {
                          hasWeightGoals.value = value;
                          setState(() => _hasWeightGoals = value); // Update _hasWeightGoals state
                        }
                      },
                    ),

                    // Conditionally display Current Weight and Weight Goal inputs if hasWeightGoals is true
                    if (hasGoals) ...[
                      TextFormField(
                        controller: currentWeightController,  // Attach the controller
                        decoration: InputDecoration(labelText: 'Current Weight ($unit)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => setState(() => _currentWeight = int.tryParse(currentWeightController.text)),
                      ),
                      TextFormField(
                        controller: weightGoalController,  // Attach the controller
                        decoration: InputDecoration(labelText: 'Weight Goal ($unit)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => setState(() => _weightGoal = int.tryParse(weightGoalController.text)),
                      ),
                    ],
                  ],
                );
              },
            ),

            // // Religion Input
            // TextFormField(
            //   decoration: const InputDecoration(labelText: 'Religion (optional)'),
            //   onSaved: (value) => setState(() => _religion = value),
            // ),

            // Chronic Conditions Multi-Select
            const Text('Any Chronic Conditions?'),
            Wrap(
              children: [
                multipleStringBox("Separate each by comma, leave blank for none.", bottomControllers[0]),
              ],
            ),

            const Text('Any Nutrient Deficiencies?'),
            Wrap(
              children: [
                multipleStringBox("Separate each by comma, leave blank for none.", bottomControllers[1]),
              ],
            ),

            const Text('Any Dietary Restrictions?'),
            Wrap(
              children: [
                multipleStringBox("Separate each by comma, leave blank for none.", bottomControllers[2]),
              ],
            ),

            const Text("Any Other Information That You Would Like To Share?"),
            Wrap(
              children: [
                multipleStringBox("e.g. Religious preferences, don't like the taste of something? etc.. ", bottomControllers[3]),
              ],
            ),

          // Add "Debug Mode" Text
          const Text("Debug Mode?"),
          Wrap(
            children: [
              // Debug Mode checkbox with ValueListenableBuilder
              ValueListenableBuilder<bool>(
                valueListenable: debugMode,
                builder: (context, isDebugEnabled, child) {
                  return CheckboxListTile(
                    title: const Text("Enable Debug Mode"),
                    value: isDebugEnabled,
                    onChanged: (value) {
                      if (value != null) {
                        debugMode.value = value; // Update ValueNotifier
                      }
                    },
                  );
                },
              ),
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
                    currentWeight: int.tryParse(currentWeightController.text),
                    weightGoal: int.tryParse(weightGoalController.text),
                    // religion: _religion,
                    chronicConditions: getCommaSeparatedValues(bottomControllers[0].text),
                    nutrientDeficiencies: getCommaSeparatedValues(bottomControllers[1].text),
                    restrictions: getCommaSeparatedValues(bottomControllers[2].text),
                    miscInformation: bottomControllers[3].text,
                    debugMode: debugMode.value
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
