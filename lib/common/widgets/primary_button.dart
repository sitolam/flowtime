import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  const PrimaryButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
        onPressed: () {
          onPressed();
        },
        icon: Icon(icon.icon));
  }
}
