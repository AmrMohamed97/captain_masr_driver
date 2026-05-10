import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import 'notification_card.dart';
import 'notification_loading_card.dart';

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final cubit = context.read<NotificationsCubit>();
        return Expanded(
          child: CustomRefreshIndicator(
            onRefresh: () {
              cubit.notifications.clear();
              cubit.pagination = null;
              cubit.page = 0;
              return cubit.getNotifications();
            },
            child: ListView.separated(
              controller: cubit.scrollController,
              padding: EdgeInsets.symmetric(vertical: 24.rH(context)),
              itemCount: cubit.notifications.length +
                  (state is NotificationsLoadingState
                      ? cubit.notifications.isEmpty
                          ? 10
                          : 3
                      : 0),
              separatorBuilder: (context, index) {
                return SizedBox(height: 8.rH(context));
              },
              itemBuilder: (context, index) {
                //! Shimmer Card
                if ((state is NotificationsLoadingState &&
                        index + 1 > cubit.notifications.length) ||
                    (state is NotificationsLoadingState &&
                        cubit.notifications.isEmpty)) {
                  return const NotificationLoadingCard();
                }
                //! Trip Card
                return NotificationCard(
                  model: cubit.notifications[index],
                  onTap: () {
                    // if (context.read<GlobalCubit>().isRider) {
                    //   if (index == 0) {
                    //     navigate(
                    //       context,
                    //       const TripDetailsView(
                    //         tripId: 0,
                    //         isAccepted: true,
                    //       ),
                    //     );
                    //   }
                    // }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
