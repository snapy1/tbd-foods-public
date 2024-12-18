// How to Use the Utility Class

// From Anywhere in Your App (without context): You can call the method statically without passing any BuildContext, which is useful in non-UI code or when you don’t have access to context:
// String unit = MeasurementUtil.getMeasurementUnit();
// print(unit); // Will print 'lbs' or 'kg' based on locale
// From Within a Widget (using context): If you’re within a widget and you want to access the locale through context, you can use the getMeasurementUnitFromContext method:

// Why Two Methods?
// getMeasurementUnit: This method works without context, so you can call it anywhere in the app.
// getMeasurementUnitFromContext: This method takes context and can be useful when you're inside a widget and want to access the locale more tightly bound to the widget lifecycle.

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MeasurementUtil {
  // Static method to get the measurement unit (lbs or kg) using PlatformDispatcher
  static String getMeasurementUnit() {
    Locale locale = ui.PlatformDispatcher.instance.locale;
    String countryCode = locale.countryCode ?? '';

    // List of countries using pounds (imperial system)
    List<String> imperialCountries = ['US', 'MM', 'LR']; // United States, Myanmar, Liberia

    // Check if the country uses the imperial system
    if (imperialCountries.contains(countryCode)) {
      return 'lbs';  // Pounds
    } else {
      return 'kg';  // Kilograms
    }
  }

  // Alternative method to get measurement unit with context, using View.of(context)
  static String getMeasurementUnitFromContext(BuildContext context) {
    Locale locale = View.of(context).platformDispatcher.locale;
    String countryCode = locale.countryCode ?? '';

    // List of countries using pounds (imperial system)
    List<String> imperialCountries = ['US', 'MM', 'LR']; // United States, Myanmar, Liberia

    // Check if the country uses the imperial system
    if (imperialCountries.contains(countryCode)) {
      return 'lbs';  // Pounds
    } else {
      return 'kg';  // Kilograms
    }
  }
}
