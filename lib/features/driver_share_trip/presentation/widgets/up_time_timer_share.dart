import 'dart:async';
import '../../../../core/imports/imports.dart';

class UpTimeTimerShare extends StatefulWidget {
  const UpTimeTimerShare({super.key, required this.arrivedTime});
  final DateTime arrivedTime;
  @override
  State<UpTimeTimerShare> createState() => _UpTimeTimerShareState();
}

class _UpTimeTimerShareState extends State<UpTimeTimerShare> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = DateTime.now().difference(widget.arrivedTime).inSeconds;
    _initTimer();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _elapsedSeconds =
            DateTime.now().difference(widget.arrivedTime).inSeconds;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int m = _elapsedSeconds ~/ 60;
    int s = _elapsedSeconds % 60;
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
