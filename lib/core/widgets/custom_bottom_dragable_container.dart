import 'dart:ui';

import '../imports/imports.dart';

class CustomBottomDragableContainer extends StatefulWidget {
  const CustomBottomDragableContainer({
    super.key,
    required this.child,
    this.startExpanded = true,
  });

  final Widget child;
  final bool startExpanded;

  @override
  State<CustomBottomDragableContainer> createState() =>
      _CustomBottomDragableContainerState();
}

class _CustomBottomDragableContainerState
    extends State<CustomBottomDragableContainer> {
  bool isBottomContainerExpanded = true;

  @override
  void initState() {
    super.initState();
    isBottomContainerExpanded = widget.startExpanded;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: isBottomContainerExpanded ? 50.rH(context) : 740.rH(context),
      left: 0,
      right: 0,
      bottom: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            // Use velocity to determine swipe direction
            final double velocityY = details.velocity.pixelsPerSecond.dy;
            if (velocityY < 0) {
              // Swipe up - expand
              isBottomContainerExpanded = true;
            } else if (velocityY > 0) {
              // Swipe down - collapse
              isBottomContainerExpanded = false;
            }
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                //! Blur Background
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        color: AppColors.black.withOpacity(.20),
                      ),
                    ),
                  ),
                ),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
