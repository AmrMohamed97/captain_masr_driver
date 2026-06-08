import '../imports/imports.dart';

class AuthHeaderRed extends StatelessWidget {
  final bool showBackButton;
  final Function()? onBackTap;

  const AuthHeaderRed({super.key, this.showBackButton = false, this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.rH(context),
      width: double.infinity,
      color: const Color(0xff800005),
      // decoration: BoxDecoration(
      // color: const Color(0xff800005),
      // borderRadius: BorderRadius.only(
      //   bottomLeft: Radius.circular(14),
      //   bottomRight: Radius.circular(14),
      // ),
      // ),
      child: Stack(
        children: [
          // Wave background
          Positioned.fill(child: CustomPaint(painter: HeaderWavePainter())),
          // Logo & text inside header
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.rH(context),
                vertical: 20.rH(context),
              ),
              child: Image.asset(
                Assets.imagesLogo,
                height: 70.rH(context),
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Back button
          if (showBackButton)
            PositionedDirectional(
              top: 50.rH(context),
              end: 20.rW(context),
              child: GestureDetector(
                onTap: onBackTap ?? () => Navigator.pop(context),
                child: Container(
                  width: 36.rH(context),
                  height: 36.rH(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  child: Center(
                    child: sl<Cache>().getLanguage() == "en"
                        ? Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18.rH(context),
                          )
                        : Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 18.rH(context),
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Base dark red gradient
    final rect = Offset.zero & size;
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffA6040B), Color(0xff800005)],
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Wave 1 (darker overlay)
    paint.shader = null;
    paint.color = Colors.black.withOpacity(0.08);
    final path1 = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.15,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path1, paint);

    // Wave 2 (another darker overlay)
    paint.color = Colors.black.withOpacity(0.06);
    final path2 = Path()
      ..moveTo(0, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.4,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path2, paint);

    // Wave 3 (lighter/highlight overlay)
    paint.color = Colors.white.withOpacity(0.04);
    final path3 = Path()
      ..moveTo(0, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.55,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
