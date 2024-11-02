import 'package:flutter/widgets.dart';

class TimerSettings extends ChangeNotifier {
  double percentage;

  void setPercentage(double newPercentage) {
    percentage = newPercentage;
    notifyListeners();
  }

  TimerSettings({required this.percentage});
}
