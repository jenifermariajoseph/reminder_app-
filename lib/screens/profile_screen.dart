import 'package:flutter/material.dart';
export 'package:flutter/material.dart';


// Change Badge to AchievementBadge
class AchievementBadge {
  final String name;
  final String imagePath;
  final int requiredXP;

  const AchievementBadge({required this.name, required this.imagePath, required this.requiredXP});
}

class ProfileScreen extends StatelessWidget {
  final int xpPoints;

  final List<AchievementBadge> badges = [
    AchievementBadge(name: "Novice", imagePath: "assets/badge1.png", requiredXP: 50),
    AchievementBadge(name: "Intermediate", imagePath: "assets/badge2.png", requiredXP: 100),
    AchievementBadge(name: "Expert", imagePath: "assets/badge3.png", requiredXP: 500),
    AchievementBadge(name: "Master", imagePath: "assets/badge4.png", requiredXP: 1000),
  ];

  List<AchievementBadge> getUnlockedBadges() {
    return badges.where((badge) => xpPoints >= badge.requiredXP).toList();
  }

  ProfileScreen({super.key, required this.xpPoints});


  int getNextBadgeXP() {
    for (var badge in badges) {
      if (xpPoints < badge.requiredXP) {
        return badge.requiredXP;
      }
    }
    return badges.last.requiredXP;
  }

  @override
  Widget build(BuildContext context) {
    final unlockedBadges = getUnlockedBadges();
    final nextBadgeXP = getNextBadgeXP();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'VT323',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/todo_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepPurple, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'PRODUCTIVITY MASTER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'VT323',
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.3),
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'XP POINTS: $xpPoints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'VT323',
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'BADGES EARNED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'VT323',
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: unlockedBadges.map((badge) {
                    final isUnlocked = xpPoints >= badge.requiredXP;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              badge.imagePath,
                              height: 60,
                              width: 60,
                              color: isUnlocked ? null : Colors.black.withOpacity(0.7),
                              colorBlendMode: isUnlocked ? BlendMode.srcIn : BlendMode.saturation,
                            ),
                            if (!isUnlocked)
                              const Icon(Icons.lock, color: Colors.white, size: 30),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          badge.name,
                          style: TextStyle(
                            color: isUnlocked ? Colors.green : Colors.grey,
                            fontFamily: 'VT323',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${badge.requiredXP} XP',
                          style: TextStyle(
                            color: isUnlocked ? Colors.green : Colors.grey,
                            fontFamily: 'VT323',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                // Add this after the XP Points container and before 'BADGES EARNED'
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: xpPoints / nextBadgeXP,
                          backgroundColor: Colors.grey[800],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          minHeight: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Progress to Next Badge: $xpPoints / $nextBadgeXP XP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'VT323',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add this function outside the ProfileScreen class
void showBadgeNotification(BuildContext context, AchievementBadge badge) {
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