import 'package:flowtime/common/widgets/amount_input_field.dart';
import 'package:flowtime/common/widgets/secondary_button.dart';
import 'package:flowtime/core/riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController breakpercentageController =
        TextEditingController(
            text: (((ref.watch(timerSettings).percentage)) * 100)
                .round()
                .toString());
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 700,
          maxHeight: 900,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
                'Preferences',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              actions: [
                SecondaryButton(
                    size: 35,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 18, left: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  // Timer settings
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Timer",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AmountInputField(
                    title: "Break Time Percentage",
                    description: "The percentage of time for a break",
                    controller: breakpercentageController,
                    onChanged: () {
                      ref.read(timerSettings).setPercentage(
                          int.parse(breakpercentageController.text) / 100);
                    },
                  ),
                  // Miscellaneous settings
                  const SizedBox(height: 20),
                  // Timer settings
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Miscellaneous",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        ref.read(timerSettings).setExtraBreak(0);
                      },
                      child: const Text("Reset extra break time")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
