import 'dart:async';
// import 'package:flutter/material.dart';

import '../../../../core/imports/imports.dart';

class DownTimeTimer extends StatefulWidget {
  final num timeMinutes;

  const DownTimeTimer({super.key, required this.timeMinutes});

  @override
  State<DownTimeTimer> createState() => _DownTimeTimerState();
}

class _DownTimeTimerState extends State<DownTimeTimer> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void didUpdateWidget(covariant DownTimeTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart or update timer if timeMinutes changes significantly,
    // though usually it stays constant for the same trip.
    if (oldWidget.timeMinutes != widget.timeMinutes && _remainingSeconds == 0) {
      _initTimer();
    }
  }

  void _initTimer() {
    _timer?.cancel();
    double minutes = double.tryParse(widget.timeMinutes?.toString() ?? '0') ?? 0;
    _remainingSeconds = (minutes * 60).toInt();

    if (_remainingSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
            _timer = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int m = _remainingSeconds ~/ 60;
    int s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingSeconds <= 0) return const SizedBox();
    return Text(
      _formattedTime,
      style: Styles.medium15(context).copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
