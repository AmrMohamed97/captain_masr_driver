import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/imports/imports.dart';

class ArrivalShareDownTimeTimer extends StatefulWidget {
  final int initialSeconds;

  const ArrivalShareDownTimeTimer({
    super.key,
    required this.initialSeconds,
  });

  @override
  State<ArrivalShareDownTimeTimer> createState() => _ArrivalShareDownTimeTimerState();
}

class _ArrivalShareDownTimeTimerState extends State<ArrivalShareDownTimeTimer> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _initTimer();
  }

  @override
  void didUpdateWidget(covariant ArrivalShareDownTimeTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSeconds != widget.initialSeconds) {
      setState(() {
        _remainingSeconds = widget.initialSeconds;
      });
      _initTimer();
    }
  }

  void _initTimer() {
    _timer?.cancel();
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
    int m = (_remainingSeconds / 60).floor();
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
