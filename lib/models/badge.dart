import 'package:flutter/material.dart';

class Badge {
  final String name;
  final String imagePath;
  final int requiredXP;

  const Badge({
    required this.name,
    required this.imagePath,
    required this.requiredXP,
  });
}

void showBadgeNotification(BuildContext context, Badge badge) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                badge.imagePath,
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'NEW BADGE UNLOCKED!',
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 28,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                badge.name,
                style: const TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 24,
                  color: Colors.green,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'AWESOME!',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
