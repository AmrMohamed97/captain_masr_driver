import '../../../../core/imports/imports.dart';
import 'notifications_list_view.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.notifications.tr(context),
          ),

          SizedBox(height: 16.rH(context)),

          //! List View
          const NotificationsListView(),
        ],
      ),
    );
  }
}
