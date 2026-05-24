
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/imports/imports.dart';
import '../../../notifications/presentation/views/notifications_view.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({
    super.key,
    required this.userId,
  });
  final int userId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navBarNavigate(
          context: context,
          widget: const NotificationsView(),
        );
      },
      child: Container(
        width: 38.rH(context),
        height: 38.rH(context),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(.90),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance
                .ref("users/$userId/unread_notifications_count")
                .onValue,
            builder: (context, snapshot) {
              int unreadCount = 0;
              if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                final value = snapshot.data!.snapshot.value;
                if (value is num) {
                  unreadCount = value.toInt();
                } else if (value is String) {
                  unreadCount = int.tryParse(value) ?? 0;
                }
              }

              final bool hasUnread = unreadCount > 0;

              return Badge(
                isLabelVisible: hasUnread,
                backgroundColor: AppColors.red,
                largeSize: 16.rH(context),
                smallSize: 8.rH(context),
                label: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: TextStyle(
                    fontSize: 8.rT(context),
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                child: CustomSvgPicture(
                  svg: Assets.imagesNotifications,
                  height: 22.rH(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
