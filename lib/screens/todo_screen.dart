import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class TodoItem {
  String title;
  bool isCompleted;
  DateTime? dueDate;
  TimeOfDay? dueTime;

  TodoItem({
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.dueTime,
  });
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addTodo(String title) {
    setState(() {
      _todos.add(TodoItem(
        title: title,
        dueDate: _selectedDate,
        dueTime: _selectedTime,
      ));
      _controller.clear();
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    debugPrint('Button pressed - attempting to show date picker');
    try {
      final DateTime now = DateTime.now();
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 5), // Set last date to 5 years from now
        builder: (context, child) {
          debugPrint('Building date picker dialog');
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.deepPurple,
                colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
                ),
              ),
              child: child!,
            ),
          );
        },
      );
      
      debugPrint('Date picker closed. Selected date: $picked');
      
      if (picked != null) {
        setState(() {
          _selectedDate = picked;
          debugPrint('State updated with date: ${_formatDate(_selectedDate)}');
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error in date picker: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              surface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.black,
              hourMinuteTextColor: Colors.white,
              dialHandColor: Colors.deepPurple,
              dialBackgroundColor: Colors.grey[900],
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        print("Selected time: ${_formatTime(_selectedTime)}"); // Debugging
      });
    } else {
      print("No time selected");
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No date';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'No time';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/todo_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Black Container for Todo Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      // Add Todo Input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'VT323',
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Add a new task...',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'VT323',
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today, color: Colors.white),
                            onPressed: () => _selectDate(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.access_time, color: Colors.white),
                            onPressed: () => _selectTime(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                _addTodo(_controller.text);
                              }
                            },
                          ),
                        ],
                      ),
                      // Show selected date/time when adding new todo
                      if (_selectedDate != null || _selectedTime != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Due: ${_formatDate(_selectedDate)} ${_formatTime(_selectedTime)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'VT323',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Todo List
                      Expanded(
                        child: ListView.builder(
                          itemCount: _todos.length,
                          itemBuilder: (context, index) {
                            final todo = _todos[index];
                            return ListTile(
                              leading: Checkbox(
                                value: todo.isCompleted,
                                onChanged: (_) => _toggleTodo(index),
                                checkColor: Colors.black,
                                fillColor: MaterialStateProperty.all(Colors.white),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todo.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'VT323',
                                      fontSize: 20,
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  if (todo.dueDate != null || todo.dueTime != null)
                                    Text(
                                      'Due: ${_formatDate(todo.dueDate)} ${_formatTime(todo.dueTime)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'VT323',
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _deleteTodo(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
