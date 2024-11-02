import 'package:flutter/material.dart';

class TimeViewer extends StatelessWidget {
  final Object minutes;
  final Object seconds;
  const TimeViewer({super.key, required this.minutes, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        "$minutes:$seconds",
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 40,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
