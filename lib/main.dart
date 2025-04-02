import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:async'; // Required for the Timer class
import 'screens/todo_screen.dart'; // Import TodoScreen

void main() {
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
      home: const HomeScreen(), // HomeScreen is set as the starting page
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GIF Background
          Positioned.fill(
            child: GifView.asset(
              'assets/pika.gif', // Path to your GIF file
              fit: BoxFit.cover,
              frameRate: 30,
            ),
          ),
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PomodoroScreen()),
                    );
                  },
                  child: const Text('Open Pomodoro Timer'),
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TodoScreen()),
                    );
                  },
                  child: const Text('Open Todo List'),
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
  int minutes = 25; // Default Pomodoro time
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

  Widget _buildTimeButton(int minutes, String label) {
    return ElevatedButton(
      onPressed: () {
        setTimer(minutes);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Timer Display
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: isRunning ? pauseTimer : startTimer,
              child: Center(
                child: Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 20,
                    fontFamily: 'VT323',
                  ),
                ),
              ),
            ),
          ),
          // Timer Controls
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Timer Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton(25, 'Pomodoro'),
                    _buildTimeButton(5, 'Short Break'),
                    _buildTimeButton(15, 'Long Break'),
                  ],
                ),
                const SizedBox(height: 20), // Add spacing
                // Go Back Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Return to HomeScreen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(fontSize: 16),
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
