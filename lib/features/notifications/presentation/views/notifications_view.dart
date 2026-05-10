import '../../../../core/imports/imports.dart';
import '../widgets/notifications_body.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: const Scaffold(
        body: NotificationsBody(),
      ),
    );
  }
}
