import '../imports/imports.dart';

void showToast(
  BuildContext context, {
  required String message,
  required ToastStates state,
  Duration duration = const Duration(seconds: 3),
}) {
  // Create an overlay entry with animation controllers
  late OverlayEntry toast;

  toast = OverlayEntry(
    builder: (context) => _ToastOverlay(
      message: message,
      state: state,
      duration: duration,
      onDismiss: () {
        toast.remove();
      },
    ),
  );

  Overlay.of(context).insert(toast);
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastStates state;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.message,
    required this.state,
    required this.duration,
    required this.onDismiss,
  });

  @override
  _ToastOverlayState createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Slide animation with bounce
    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0.1),
        ),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: const Offset(0, 0),
        ),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();

    // Schedule dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted && !_isDismissing) {
        _dismissToast();
      }
    });
  }

  void _dismissToast() {
    _isDismissing = true;
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          top: 50.rH(context),
          left: 16.rW(context),
          right: 16.rW(context),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _dismissToast();
                  }
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.rW(context),
                      vertical: 12.rH(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _getStateColor(widget.state),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // State icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _getStateColor(widget.state).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIconForState(widget.state),
                            color: _getStateColor(widget.state),
                            size: 20.rH(context),
                          ),
                        ),
                        SizedBox(width: 12.rW(context)),
                        // Message
                        Expanded(
                          child: Text(
                            widget.message,
                            style: Styles.regular16(context),
                            overflow: TextOverflow.clip,
                            maxLines: 3,
                          ),
                        ),
                        // Close button
                        GestureDetector(
                          onTap: _dismissToast,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 16.rH(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForState(ToastStates state) {
    switch (state) {
      case ToastStates.success:
        return Icons.check_circle;
      case ToastStates.error:
        return Icons.error;
      case ToastStates.warning:
        return Icons.warning_amber;
      case ToastStates.info:
        return Icons.info;
    }
  }

  Color _getStateColor(ToastStates state) {
    switch (state) {
      case ToastStates.success:
        return AppColors.primary;
      case ToastStates.error:
        return AppColors.red;
      case ToastStates.warning:
        return Colors.amber;
      case ToastStates.info:
        return Colors.blue;
    }
  }
}

enum ToastStates {
  success,
  error,
  warning,
  info,
}
