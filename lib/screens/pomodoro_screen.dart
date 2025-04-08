import 'package:flutter/material.dart';
import 'dart:async';


class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int minutes = 25;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (!isRunning) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    if (timer != null) {
      timer!.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }

  void resetTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      minutes = 25;
      seconds = 0;
      isRunning = false;
    });
  }

  void setCustomTime(int mins) {
    setState(() {
      minutes = mins;
      seconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeButton(minutes: 25, onTap: setCustomTime),
                TimeButton(minutes: 15, onTap: setCustomTime),
                TimeButton(minutes: 5, onTap: setCustomTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeButton extends StatelessWidget {
  final int minutes;
  final Function(int) onTap;

  TimeButton({required this.minutes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => onTap(minutes),
        child: Text('${minutes}min'),
      ),
    );
  }
}