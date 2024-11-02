import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;
  final int size;
  const SecondaryButton(
      {super.key, required this.icon, required this.onPressed, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
        iconSize: size.toDouble() / 2,
        color: Theme.of(context).colorScheme.secondary,
        style: ButtonStyle(
            minimumSize:
                WidgetStateProperty.all(Size(size.toDouble(), size.toDouble())),
            maximumSize:
                WidgetStateProperty.all(Size(size.toDouble(), size.toDouble())),
            backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainer)),
        onPressed: () {
          onPressed();
        },
        icon: Icon(icon.icon));
  }
}
