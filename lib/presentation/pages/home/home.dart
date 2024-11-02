import 'package:flowtime/common/widgets/primary_button.dart';
import 'package:flowtime/common/widgets/secondary_button.dart';
import 'package:flowtime/common/widgets/time.dart';
import 'package:flowtime/core/riverpod/riverpod.dart';
import 'package:flowtime/presentation/pages/home/widgets/title.dart';
import 'package:flowtime/presentation/pages/settings/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends ConsumerStatefulWidget {
  final AudioPlayer audioPlayer = AudioPlayer();
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsDialog();
                      });
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: mode == 'countUp'
            ? _workTimer(context, ref)
            : mode == 'countDown'
                ? _breakTimer(context)
                : mode == 'overTime'
                    ? _overTime(context)
                    : mode == 'overTimeTimer'
                        ? _overTimeTimer(context)
                        : Container());
  }

  Widget _workTimer(BuildContext context, WidgetRef ref) {
    return Column(
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
                TimeViewer(minutes: minutes, seconds: seconds),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                        onPressed: () {
                          _stopWatchTimer.isRunning
                              ? _stopWatchTimer.onStopTimer()
                              : _stopWatchTimer.onStartTimer();
                        },
                        icon: Icon(_stopWatchTimer.isRunning
                            ? Icons.pause
                            : Icons.play_arrow)),
                    const SizedBox(width: 20),
                    SecondaryButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: () {
                          setState(() {
                            _stopWatchTimer.onStopTimer();

                            _countDownTimer.setPresetSecondTime(
                                (StopWatchTimer.getRawSecond(value) *
                                            ref.watch(timerSettings).percentage)
                                        .round() +
                                    extraBreak);
                            extraBreak = 0;
                            _countDownTimer.onStartTimer();
                            mode = 'countDown';
                          });
                        }),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _breakTimer(BuildContext context) {
    return Column(
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
                TimeViewer(minutes: minutes, seconds: seconds),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                        icon: Icon(_countDownTimer.isRunning
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          _countDownTimer.isRunning
                              ? _countDownTimer.onStopTimer()
                              : _countDownTimer.onStartTimer();
                        }),
                    const SizedBox(width: 20),
                    SecondaryButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: () {
                          setState(() {
                            extraBreak = StopWatchTimer.getRawSecond(value);
                            _stopWatchTimer.onResetTimer();
                            _stopWatchTimer.onStartTimer();
                            mode = 'countUp';
                          });
                        }),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _overTime(BuildContext context) {
    return Column(
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
                    PrimaryButton(
                        icon: Icon(_stopWatchTimer.isRunning
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          _stopWatchTimer.isRunning
                              ? _stopWatchTimer.onStopTimer()
                              : _stopWatchTimer.onStartTimer();
                        }),
                    const SizedBox(width: 20),
                    SecondaryButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: () {
                          setState(() {
                            _stopWatchTimer.onStopTimer();

                            _countDownTimer.setPresetSecondTime(
                                (StopWatchTimer.getRawSecond(value)).round());
                            _countDownTimer.onStartTimer();
                            mode = 'overTimeTimer';
                          });
                        }),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _overTimeTimer(BuildContext context) {
    return Column(
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
                    PrimaryButton(
                        icon: Icon(_countDownTimer.isRunning
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          _countDownTimer.isRunning
                              ? _countDownTimer.onStopTimer()
                              : _countDownTimer.onStartTimer();
                        }),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
