import 'package:flutter/material.dart';
import 'package:inner_glow/inner_glow.dart';

class CustomInnerGlow {
  Color currentColor;
  double height;
  double width;
  final double glowRadius;
  final double glowBlur;
  final double thickness;

  CustomInnerGlow({
    required this.height,
    required this.width,
    required this.glowRadius,
    required this.glowBlur,
    required this.thickness,
    this.currentColor = Colors.transparent, // Default color is transparent
  });

  Widget buildGlowingBorder(BuildContext context) {
    return Positioned.fill(
      child: InnerGlow(
        width: width,  // Use provided width
        height: height, // Use provided height
        glowRadius: glowRadius,
        glowBlur: glowBlur,
        thickness: thickness,
        strokeLinearGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [currentColor, currentColor.withOpacity(0.5)],
        ),
        baseDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0), // No rounded corners
        ),
      ),
    );
  }

  // Function to update the glow color
  void updateColor(Color newColor) { currentColor = newColor; }

  /// returns a color value from either red to yellow, or yellow to green
  /// depending on the integer value that is provided it it. 
  /// 
  /// The value must be from 0 to 100. 
  /// The lower the value the more red the color. 
  /// The higher the value the more green the color. 
  Color getColorForValue(double value) {
    if (value < 0) value = 0;  // Clamp value to 0 if it's below 0
    if (value > 100) value = 100;  // Clamp value to 100 if it's above 100

    if (value <= 50) {
      // Red to Yellow transition
      int red = 255;
      int green = (value / 50 * 255).toInt();  // Scale from 0 to 255
      int blue = 0;
      return Color.fromARGB(255, red, green, blue);
    } else {
      // Yellow to Green transition
      int red = ((100 - value) / 50 * 255).toInt();  // Scale from 255 to 0
      int green = 255;
      int blue = 0;
      return Color.fromARGB(255, red, green, blue);
    }
  }


}
