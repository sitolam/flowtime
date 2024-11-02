import 'package:flutter/material.dart';

class AmountInputField extends StatelessWidget {
  final String title;
  final String description;
  final TextEditingController controller;
  final Function() onChanged;
  const AmountInputField({
    super.key,
    required this.title,
    required this.description,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  onChanged();
                }
              },
              child: TextField(
                onEditingComplete: () {
                  onChanged();
                },
                controller: controller,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
