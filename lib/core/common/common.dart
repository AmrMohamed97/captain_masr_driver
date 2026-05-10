import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../imports/imports.dart';

navigate(BuildContext context, Widget screen, {Function(dynamic)? then}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const ZoomPageTransitionsBuilder().buildTransitions(
          MaterialPageRoute(builder: (context) => screen),
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    ),
  ).then((value) {
    if (then != null) {
      then(value);
    }
  });
}

void navigateReplacement(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const ZoomPageTransitionsBuilder().buildTransitions(
          MaterialPageRoute(builder: (context) => screen),
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    ),
  );
}

Future<void> navigateAndRemoveUntil(context, widget) {
  return Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
    (route) {
      return false;
    },
  );
}

navBarNavigate({
  required BuildContext context,
  required Widget widget,
  bool? withNavBar,
  Function(dynamic)? then,
}) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: widget,
    withNavBar: withNavBar ?? false,
    pageTransitionAnimation: PageTransitionAnimation.fade,
    customPageRoute: PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  ).then((value) {
    if (then != null) {
      then(value);
    }
  });
}

Future<MultipartFile?> uploadImageToApi(XFile? image) async {
  if (image == null) return null;
  return await MultipartFile.fromFile(
    image.path,
    filename: image.path.split('/').last,
  );
}

Future<List<MultipartFile>> uploadImageListToApi(List<XFile> images) async {
  final List<MultipartFile> list = [];
  for (var image in images) {
    final MultipartFile file = await MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
    );
    list.add(file);
  }
  return list;
}

String timeAgo(String input, String locale) {
  final dateTime = parseTime(input);
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) return locale == 'ar' ? 'الآن' : 'Just now';
  if (diff.inMinutes < 60) {
    return locale == 'ar'
        ? 'منذ ${diff.inMinutes} دقيقة'
        : '${diff.inMinutes} min ago';
  }
  if (diff.inHours < 24) {
    return locale == 'ar'
        ? 'منذ ${diff.inHours} ساعة'
        : '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  }
  if (diff.inDays == 1) return locale == 'ar' ? 'أمس' : 'Yesterday';
  if (diff.inDays < 7) {
    return locale == 'ar'
        ? 'منذ ${diff.inDays} أيام'
        : '${diff.inDays} days ago';
  }
  if (diff.inDays < 14) return locale == 'ar' ? 'منذ أسبوع' : '1 week ago';
  if (diff.inDays < 30) {
    final weeks = (diff.inDays / 7).floor();
    return locale == 'ar' ? 'منذ $weeks أسابيع' : '$weeks weeks ago';
  }

  final format = DateFormat('dd MMM yyyy', locale);
  return format.format(dateTime);
}

DateTime parseTime(String utcTimestamp) {
  final DateTime utcTime = DateTime.parse(utcTimestamp);
  return utcTime;
}

formatTime({required String time, required String language}) {
  DateTime dateTime;
  // Handle both "HH:mm" format (from API) and ISO 8601 (from Firebase)
  if (RegExp(r'^\d{2}:\d{2}$').hasMatch(time)) {
    // Format is "HH:mm" — parse manually using today's date
    final parts = time.split(':');
    final now = DateTime.now();
    dateTime = DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  } else {
    dateTime = DateTime.parse(time);
  }
  final DateFormat format = DateFormat('HH:mm a', language);
  return format.format(dateTime);
}
