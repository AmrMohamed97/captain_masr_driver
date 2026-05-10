import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.model,
  });

  final TransactionModel model;

  //! Format Date
  String formatDate(String input, String locale) {
    final dateTime = DateTime.parse(input);
    final formatter = DateFormat('MMMM d, h:mm a', locale);
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 77.rH(context),
      margin: EdgeInsets.only(
        bottom: 14.rH(context),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12.rH(context),
        horizontal: 8.rW(context),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rH(context)),
            color: AppColors.black.withOpacity(.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          //! User Image
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              model.user?.profilePicture ?? "",
              width: 53.rH(context),
              height: 53.rH(context),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                Assets.imagesPersonSvg,
                color: AppColors.grey,
              ),
            ),
          ),

          SizedBox(width: 13.rW(context)),

          //! Date & Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //! Date
                Text(
                  model.time != null
                      ? formatDate(
                          model.time!, context.read<GlobalCubit>().language)
                      : "",
                  style: Styles.medium12(context).copyWith(
                    color: AppColors.greyText,
                  ),
                ),
                SizedBox(height: 5.rH(context)),
                //! Name
                Text(
                  model.user?.username ?? "",
                  style: Styles.medium15(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.rW(context)),

          //! Transfer Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! Title
              Text(
                model.action == "transfer"
                    ? AppStrings.transfer.tr(context)
                    : AppStrings.receive.tr(context),
                style: Styles.medium12(context).copyWith(
                  color: AppColors.green,
                ),
              ),
              SizedBox(height: 5.rH(context)),
              //! Amount
              Text(
                "-${model.amount ?? 0} ${AppStrings.egp.tr(context)}"
                    .replaceAll("-", model.action == "transfer" ? "-" : "+"),
                style: Styles.semibold16Primary(context).copyWith(
                  color: context.read<GlobalCubit>().isRider
                      ? AppColors.red
                      : AppColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
