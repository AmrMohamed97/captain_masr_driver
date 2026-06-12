import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/imports/imports.dart';

class RaceDurationCounterDown extends StatefulWidget {
  final num duration;
  final DateTime startTime;
  final DateTime currentTime;

  const RaceDurationCounterDown({
    super.key,
    required this.duration,
    required this.startTime,
    required this.currentTime,
  });

  @override
  State<RaceDurationCounterDown> createState() => _RaceDurationCounterDownState();
}

class _RaceDurationCounterDownState extends State<RaceDurationCounterDown> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void didUpdateWidget(covariant RaceDurationCounterDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime || oldWidget.duration != widget.duration) {
      _initTimer();
    }
  }

  void _initTimer() {
    _timer?.cancel();
    int durationInSeconds = (widget.duration * 60).toInt();
    int elapsedSeconds = DateTime.now().difference(widget.startTime).inSeconds;
    _remainingSeconds = durationInSeconds - elapsedSeconds;

    if (_remainingSeconds < 0) {
      _remainingSeconds = 0;
    }

    if (_remainingSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          int elapsed = DateTime.now().difference(widget.startTime).inSeconds;
          _remainingSeconds = durationInSeconds - elapsed;
          if (_remainingSeconds <= 0) {
            _remainingSeconds = 0;
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
    return Text(
      _formattedTime,
      style: Styles.medium15(context).copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
