import 'package:flutter/material.dart';
import 'package:tbd_foods/health_data/food.dart';
import 'package:tbd_foods/server_connection/server_connection.dart';
import 'package:tbd_foods/user_management/user.dart';

class MoreInformation extends StatelessWidget {
  final User? user;
  final ServerConnection? server;
  final Food? food;
  final double marginWidth;
  final double marginHeight;
  final VoidCallback onClose;

  const MoreInformation({
    super.key,
    required this.user,
    required this.server,
    required this.food,
    required this.onClose,
    this.marginWidth = 16.0,
    this.marginHeight = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: marginWidth,
          vertical: marginHeight,
        ),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Detailed Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'This app is still in early development, you are currently using an unofficial release.\nThis app is powerd by ChompFoods API.\nThis will be a detailed description of the food item and related health information.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: onClose,
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
