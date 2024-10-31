import 'package:flowtime/presentation/pages/home/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  final AudioPlayer audioPlayer = AudioPlayer();
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StopWatchTimer _stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countUp);
  final StopWatchTimer _countDownTimer =
      StopWatchTimer(mode: StopWatchMode.countDown);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
    await _countDownTimer.dispose();
  }

  String mode = 'countUp';
  int extraBreak = 0;

  @override
  Widget build(BuildContext context) {
    if (mode == 'countUp') return _workTimer(context);
    if (mode == 'countDown') return _breakTimer(context);
    if (mode == 'overTime') return _overTime(context);
    if (mode == 'overTimeTimer') return _overTimeTimer(context);

    return Container(); // Add a default return to avoid null return
  }

  Widget _workTimer(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StageTitle(title: "Work Stage"),
          StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: 0,
            builder: (context, snap) {
              final value = snap.data;
              final minutes = StopWatchTimer.getRawMinute(value!) < 10
                  ? StopWatchTimer.getDisplayTimeMinute(value)
                  : StopWatchTimer.getRawMinute(value);
              final seconds = StopWatchTimer.getDisplayTimeSecond(value);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "$minutes:$seconds",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                          onPressed: () {
                            _stopWatchTimer.isRunning
                                ? _stopWatchTimer.onStopTimer()
                                : _stopWatchTimer.onStartTimer();
                          },
                          icon: Icon(_stopWatchTimer.isRunning
                              ? Icons.pause
                              : Icons.play_arrow)),
                      const SizedBox(width: 20),
                      IconButton.filled(
                          color: Theme.of(context).colorScheme.secondary,
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer)),
                          onPressed: () {
                            setState(() {
                              _stopWatchTimer.onStopTimer();

                              _countDownTimer.setPresetSecondTime(
                                  (StopWatchTimer.getRawSecond(value) * 0.20)
                                          .round() +
                                      extraBreak);
                              extraBreak = 0;
                              _countDownTimer.onStartTimer();
                              mode = 'countDown';
                            });
                          },
                          icon: const Icon(Icons.skip_next))
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _breakTimer(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StageTitle(title: "Break Stage"),
          StreamBuilder<int>(
            stream: _countDownTimer.rawTime,
            initialData: 0,
            builder: (context, snap) {
              final value = snap.data;
              final minutes = StopWatchTimer.getRawMinute(value!) < 10
                  ? StopWatchTimer.getDisplayTimeMinute(value)
                  : StopWatchTimer.getRawMinute(value);
              final seconds = StopWatchTimer.getDisplayTimeSecond(value);

              if (StopWatchTimer.getRawSecond(value) == 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    widget.audioPlayer
                        .play(AssetSource('audio/wrong.mp3'), volume: 0.3);
                    _countDownTimer.onStopTimer();
                    _stopWatchTimer.onResetTimer();
                    _stopWatchTimer.onStartTimer();
                    mode = 'overTime';
                  });
                });
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "$minutes:$seconds",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                          onPressed: () {
                            _countDownTimer.isRunning
                                ? _countDownTimer.onStopTimer()
                                : _countDownTimer.onStartTimer();
                          },
                          icon: Icon(_countDownTimer.isRunning
                              ? Icons.pause
                              : Icons.play_arrow)),
                      const SizedBox(width: 20),
                      IconButton.filled(
                          color: Theme.of(context).colorScheme.secondary,
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer)),
                          onPressed: () {
                            setState(() {
                              extraBreak = StopWatchTimer.getRawSecond(value);
                              _stopWatchTimer.onResetTimer();
                              _stopWatchTimer.onStartTimer();
                              mode = 'countUp';
                            });
                          },
                          icon: const Icon(Icons.skip_next))
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _overTime(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StageTitle(title: "Overtime"),
          StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: 0,
            builder: (context, snap) {
              final value = snap.data;
              final minutes = StopWatchTimer.getRawMinute(value!) < 10
                  ? StopWatchTimer.getDisplayTimeMinute(value)
                  : StopWatchTimer.getRawMinute(value);
              final seconds = StopWatchTimer.getDisplayTimeSecond(value);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 8, left: 0, right: 8),
                    child: Text(
                      "+$minutes:$seconds",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                          onPressed: () {
                            _stopWatchTimer.isRunning
                                ? _stopWatchTimer.onStopTimer()
                                : _stopWatchTimer.onStartTimer();
                          },
                          icon: Icon(_stopWatchTimer.isRunning
                              ? Icons.pause
                              : Icons.play_arrow)),
                      const SizedBox(width: 20),
                      IconButton.filled(
                          color: Theme.of(context).colorScheme.secondary,
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer)),
                          onPressed: () {
                            setState(() {
                              _stopWatchTimer.onStopTimer();

                              _countDownTimer.setPresetSecondTime(
                                  (StopWatchTimer.getRawSecond(value)).round());
                              _countDownTimer.onStartTimer();
                              mode = 'overTimeTimer';
                            });
                          },
                          icon: const Icon(Icons.skip_next))
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _overTimeTimer(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StageTitle(title: "Work Stage"),
          StreamBuilder<int>(
            stream: _countDownTimer.rawTime,
            initialData: 0,
            builder: (context, snap) {
              final value = snap.data;
              final minutes = StopWatchTimer.getRawMinute(value!) < 10
                  ? StopWatchTimer.getDisplayTimeMinute(value)
                  : StopWatchTimer.getRawMinute(value);
              final seconds = StopWatchTimer.getDisplayTimeSecond(value);

              if (StopWatchTimer.getRawSecond(value) == 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _countDownTimer.onStopTimer();
                    _stopWatchTimer.onResetTimer();
                    _stopWatchTimer.onStartTimer();
                    mode = 'countUp';
                  });
                });
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 8, left: 0, right: 8),
                    child: Text(
                      "-$minutes:$seconds",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                          onPressed: () {
                            _countDownTimer.isRunning
                                ? _countDownTimer.onStopTimer()
                                : _countDownTimer.onStartTimer();
                          },
                          icon: Icon(_countDownTimer.isRunning
                              ? Icons.pause
                              : Icons.play_arrow)),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
