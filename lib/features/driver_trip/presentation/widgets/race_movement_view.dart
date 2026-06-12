import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/imports/imports.dart';

class RaceMovementView extends StatefulWidget {
  final num duration;
  final DateTime startTime;
  final DateTime currentTime;

  const RaceMovementView({
    super.key,
    required this.duration,
    required this.startTime,
    required this.currentTime,
  });

  @override
  State<RaceMovementView> createState() => _RaceMovementViewState();
}

class _RaceMovementViewState extends State<RaceMovementView> {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void didUpdateWidget(covariant RaceMovementView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime || oldWidget.duration != widget.duration) {
      _initTimer();
    }
  }

  void _initTimer() {
    _timer?.cancel();
    _totalSeconds = (widget.duration * 60).toInt();
    int elapsedSeconds = DateTime.now().difference(widget.startTime).inSeconds;
    _remainingSeconds = _totalSeconds - elapsedSeconds;

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
          _remainingSeconds = _totalSeconds - elapsed;
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

  @override
  Widget build(BuildContext context) {
    double progress = _totalSeconds == 0
        ? 1.0
        : (_totalSeconds - _remainingSeconds) / _totalSeconds;
    progress = progress.clamp(0.0, 1.0);

    final double containerWidth = 295.rW(context);
    final double scooterWidth = 22.rH(context);

    return SizedBox(
      height: 50.rH(context),
      width: containerWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 8.rH(context),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            backgroundColor: AppColors.grey,
            borderRadius: BorderRadius.circular(6),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(seconds: 1),
            start: progress * (containerWidth - scooterWidth),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 11.rH(context),
                  backgroundColor: AppColors.grey,
                  child: CircleAvatar(
                    radius: 10.rH(context),
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 9.rH(context),
                      backgroundColor: AppColors.primary,
                      child: Padding(
                        padding: EdgeInsets.all(2.rH(context)),
                        child: Image.asset(
                          Assets.imagesScooterPng,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
