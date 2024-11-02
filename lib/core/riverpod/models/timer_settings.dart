import 'package:flutter/widgets.dart';

class TimerSettings extends ChangeNotifier {
  int extraBreak;

  void setExtraBreak(int newExtraBreak) {
    extraBreak = newExtraBreak;
    notifyListeners();
  }

  double percentage;

  void setPercentage(double newPercentage) {
    percentage = newPercentage;
    notifyListeners();
  }

  TimerSettings({
    required this.percentage,
    required this.extraBreak,
  });
}
