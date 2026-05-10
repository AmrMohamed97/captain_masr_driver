import '../../../../core/imports/imports.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  final NotificationModel model;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.rH(context),
          horizontal: 16.rW(context),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyText.withOpacity(.20),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Icon !(Replace With Url Image)
            Image.asset(
              Assets.imagesNotificationSuccess,
              height: 32.rH(context),
              width: 32.rW(context),
              fit: BoxFit.contain,
            ),

            SizedBox(width: 12.rH(context)),

            //! Title & Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.title ?? "",
                    style: Styles.semibold14Primary(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4.rH(context)),
                  Text(
                    model.body ?? "",
                    style: Styles.regular12(context).copyWith(
                      color: AppColors.greyText,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.rW(context)),

            //! Time Ago
            Text(
              model.createdAt != null
                  ? timeAgo(
                      model.createdAt!,
                      context.read<GlobalCubit>().language,
                    )
                  : "",
              style: Styles.regular14(context).copyWith(
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
