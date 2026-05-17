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

          SizedBox(height: 12.rH(context)),

          //! Unread count banner
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final cubit = context.read<NotificationsCubit>();
              final count = cubit.unreadCount;

              if (state is NotificationsLoadingState &&
                  cubit.notifications.isEmpty) {
                return const SizedBox.shrink();
              }

              if (count == 0) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12.rH(context)),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.rW(context),
                  vertical: 12.rH(context),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff05C1CF), Color(0xff02767E)],
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff009EAA).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.white,
                        size: 20.rT(context),
                      ),
                    ),
                    SizedBox(width: 12.rW(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$count ${AppStrings.unreadNotifications.tr(context)}',
                            style: Styles.semibold14Primary(context).copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.rH(context)),
                          Text(
                            AppStrings.tapToReadAll.tr(context),
                            style: Styles.regular12(context).copyWith(
                              color: AppColors.white.withOpacity(0.80),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 13.rT(context),
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff009EAA),
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          //! List View
          const NotificationsListView(),
        ],
      ),
    );
  }
}
