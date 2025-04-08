import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:async';
import 'screens/todo_screen.dart';
import 'screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Fixed import

// XP Points Tracking
class UserData {
  static int xpPoints = 0; // XP points tracking

  static Future<void> loadXP() async {
    final prefs = await SharedPreferences.getInstance();
    xpPoints = prefs.getInt('xpPoints') ?? 0;
  }

  static Future<void> saveXP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xpPoints', xpPoints);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserData.loadXP();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _refreshBadges() {
    setState(() {});
  }

  final List<AchievementBadge> badges = [
    AchievementBadge(name: "Novice", imagePath: "assets/badge1.png", requiredXP: 50),
    AchievementBadge(name: "Intermediate", imagePath: "assets/badge2.png", requiredXP: 100),
    AchievementBadge(name: "Expert", imagePath: "assets/badge3.png", requiredXP: 500),
    AchievementBadge(name: "Master", imagePath: "assets/badge4.png", requiredXP: 1000),
  ];

  List<AchievementBadge> getUnlockedBadges() {
    return badges.where((badge) => UserData.xpPoints >= badge.requiredXP).toList();
  }

  @override
  Widget build(BuildContext context) {
    final unlockedBadges = getUnlockedBadges();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GifView.asset(
              'assets/pika.gif',
              fit: BoxFit.cover,
              frameRate: 30,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Profile Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(xpPoints: UserData.xpPoints),
                            ),
                          ).then((_) => _refreshBadges());
                        },
                      ),
                    ),
                  ),
                ),
                // Centered Content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PomodoroScreen()),
                            ).then((_) => _refreshBadges());
                          },
                          child: const Text('Open Pomodoro Timer'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TodoScreen()),
                            ).then((_) => _refreshBadges());
                          },
                          child: const Text('Open Todo List'),
                        ),
                        // Add Badge Display
                        const SizedBox(height: 40),
                        if (unlockedBadges.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'UNLOCKED BADGES',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'VT323',
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: unlockedBadges.map((badge) {
                                    return Column(
                                      children: [
                                        Image.asset(
                                          badge.imagePath,
                                          height: 40,
                                          width: 40,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          badge.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'VT323',
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int minutes = 25;
  int seconds = 0;
  bool isRunning = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (!isRunning) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            timer.cancel();
            isRunning = false;
            _showCompletionDialog();
          }
        });
      });
      setState(() {
        isRunning = true;
      });
    }
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void setTimer(int mins) {
    timer?.cancel();
    setState(() {
      minutes = mins;
      seconds = 0;
      isRunning = false;
    });
  }

  void completeNow() {
    timer?.cancel();
    setState(() {
      minutes = 0;
      seconds = 0;
      isRunning = false;
      _showCompletionDialog();
    });
  }

  void _showCompletionDialog() async {
    UserData.xpPoints += 25;
    await UserData.saveXP(); // Save XP points when earned
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
                  'assets/PUG.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'YOU HAVE DONE IT BISH!!',
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
                  '+25 XP POINTS EARNED!',
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:           [
            // Timer Display
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: isRunning ? pauseTimer : startTimer,
                child: Center(
                  child: Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 100, // Slightly smaller
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 15, // Adjusted spacing
                      fontFamily: 'VT323',
                    ),
                  ),
                ),
              ),
            ),
            // Timer Controls
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Timer Preset Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTimeButton(25, 'Pomodoro'),
                        _buildTimeButton(5, 'Short'),
                        _buildTimeButton(15, 'Long'),
                      ],
                    ),
                    // Start/Pause Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          ),
                          child: const Text('Start'),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: pauseTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          ),
                          child: const Text('Pause'),
                        ),
                      ],
                    ),
                    // Complete and Back Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: completeNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          ),
                          child: const Text('Complete'),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          ),
                          child: const Text('Back'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(int minutes, String label) {
    return ElevatedButton(
      onPressed: () => setTimer(minutes),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
