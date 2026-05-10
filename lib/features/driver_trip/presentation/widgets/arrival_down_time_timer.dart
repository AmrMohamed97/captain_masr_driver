import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';

class ArrivalDownTimeTimer extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;

  const ArrivalDownTimeTimer({
    super.key,
    required this.origin,
    required this.destination,
  });

  @override
  State<ArrivalDownTimeTimer> createState() => _ArrivalDownTimeTimerState();
}

class _ArrivalDownTimeTimerState extends State<ArrivalDownTimeTimer> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDuration();
  }

  @override
  void didUpdateWidget(covariant ArrivalDownTimeTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.origin != widget.origin ||
        oldWidget.destination != widget.destination) {
      if (_remainingSeconds == 0 && !_isLoading) {
        setState(() {
          _isLoading = true;
        });
        _fetchDuration();
      }
    }
  }

  Future<void> _fetchDuration() async {
    try {
      const apiKey = "AIzaSyCuOWpUhowE4hXXmyFi0P_2wlCBQu6cFt4";
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${widget.origin.latitude},${widget.origin.longitude}&destination=${widget.destination.latitude},${widget.destination.longitude}&key=$apiKey";

      final response = await Dio().get(url);

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final routes = response.data['routes'] as List;
        if (routes.isNotEmpty) {
          final legs = routes[0]['legs'] as List;
          if (legs.isNotEmpty) {
            final durationValue = legs[0]['duration']['value'];
            if (mounted) {
              setState(() {
                _remainingSeconds = int.tryParse(durationValue.toString()) ?? 0;
                _isLoading = false;
              });
              _initTimer();
            }
            return;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching directions: $e");
    }

    // Fallback if failed
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
    if (_isLoading) {
      return SizedBox(
        height: 15.rH(context),
        width: 15.rH(context),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    return Text(
      _formattedTime,
      style: Styles.medium15(context).copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
