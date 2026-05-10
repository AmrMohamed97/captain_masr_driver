import '../../../../core/imports/imports.dart';

class SendingOrRecievingRow extends StatelessWidget {
  const SendingOrRecievingRow({
    super.key,
    required this.sending,
  });

  final bool sending;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgPicture(
          svg: sending ? Assets.imagesSending : Assets.imagesRecieving,
          height: 18.rH(context),
        ),
        SizedBox(width: 8.rW(context)),
        Text(
          sending
              ? AppStrings.sending.tr(context)
              : AppStrings.receiving.tr(context),
          style: Styles.semibold14Primary(context).copyWith(
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }
}
