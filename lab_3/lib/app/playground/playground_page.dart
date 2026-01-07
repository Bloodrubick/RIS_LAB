import 'package:flutter/material.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  String? _result;

  Future<void> _showDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dialog'),
        content: const Text('This is a dialog'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted && result != null) {
      setState(() {
        _result = 'Dialog result: $result';
      });
    }
  }

  Future<void> _showModalBottomSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('This is a modal bottom sheet'),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Close'),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
     if (mounted && result != null) {
      setState(() {
        _result = 'BottomSheet result: $result';
      });
    }
  }

  Future<void> _showDatePicker() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
     if (mounted && result != null) {
      setState(() {
        _result = 'Date: ${result.toIso8601String()}';
      });
    }
  }

   Future<void> _showTimePicker() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
     if (mounted && result != null) {
      setState(() {
        _result = 'Time: ${result.format(context)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_result != null) ...[
              Text(_result!, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _showDialog,
              child: const Text('Show Dialog'),
            ),
            ElevatedButton(
              onPressed: _showModalBottomSheet,
              child: const Text('Show Modal Bottom Sheet'),
            ),
            ElevatedButton(
              onPressed: _showDatePicker,
              child: const Text('Show Date Picker'),
            ),
            ElevatedButton(
              onPressed: _showTimePicker,
              child: const Text('Show Time Picker'),
            ),
            const SizedBox(height: 20),
             ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Result from Playground');
              },
              child: const Text('Return Result'),
            ),
          ],
        ),
      ),
    );
  }
}
