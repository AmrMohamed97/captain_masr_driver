import '../../../../core/imports/imports.dart';
import '../../data/models/message_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.isSender,
    required this.model,
  });

  final bool isSender;
  final MessageModel model;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (!isSender)
              //   Padding(
              //     padding: EdgeInsetsDirectional.only(
              //       end: 16.rW(context),
              //     ),
              //     child: Badge(
              //       isLabelVisible: true,
              //       backgroundColor: AppColors.primary,
              //       smallSize: 8.rH(context),
              //       child: CircleAvatar(
              //         radius: 25.rH(context),
              //         backgroundColor: AppColors.transparent,
              //         child: Image.asset(
              //           Assets.imagesTestProfile1,
              //           height: 50.rH(context),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //   ),
              Container(
                constraints: BoxConstraints(maxWidth: 300.rW(context)),
                padding: EdgeInsets.symmetric(
                  vertical: 16.rH(context),
                  horizontal: 11.rW(context),
                ),
                decoration: BoxDecoration(
                  color: isSender
                      ? AppColors.primary
                      : AppColors.grey.withOpacity(.83),
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(20),
                    topEnd: const Radius.circular(20),
                    bottomEnd: Radius.circular(isSender ? 0 : 20),
                    bottomStart: Radius.circular(isSender ? 20 : 0),
                  ),
                ),
                child: Text(
                  model.message ?? "",
                  style: Styles.medium14(context).copyWith(
                    color: isSender ? AppColors.white : AppColors.black,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          //! Status
          if (isSender)
            Padding(
              padding: EdgeInsets.only(top: 8.rH(context)),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  model.isSeen == true
                      ? AppStrings.readed.tr(context)
                      : AppStrings.sent.tr(context),
                  style: Styles.medium12(context).copyWith(
                    color: AppColors.greyText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
