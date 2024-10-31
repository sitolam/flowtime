import 'package:flutter/material.dart';

class StageTitle extends StatelessWidget {
  final String title;
  const StageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
            decoration: TextDecoration.none,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
