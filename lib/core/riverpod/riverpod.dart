import 'package:flowtime/core/riverpod/models/timer_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerSettings = ChangeNotifierProvider<TimerSettings>((ref) {
  return TimerSettings(percentage: 0.2);
});
