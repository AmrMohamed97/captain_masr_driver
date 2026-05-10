import '../../../../core/imports/imports.dart';

class DeliverySendingOrReveiving extends StatelessWidget {
  const DeliverySendingOrReveiving({
    super.key,
  });

  static List<Map> items = [
    {
      "svg": Assets.imagesSending,
      "title": AppStrings.sending,
    },
    {
      "svg": Assets.imagesRecieving,
      "title": AppStrings.receiving,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        final cubit = context.read<DeliveryCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
            (index) {
              final bool selected = (cubit.isSending && index == 0) ||
                  (!cubit.isSending && index == 1);
              return GestureDetector(
                onTap: () => cubit.sendingOrReceivingToggle(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 159.rW(context),
                  height: 40.rH(context),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withOpacity(.12)
                        : AppColors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //! Icon
                      CustomSvgPicture(
                        svg: items[index]["svg"],
                        height: 23.rH(context),
                      ),
                      SizedBox(width: 8.rW(context)),
                      //! Title
                      Text(
                        (items[index]["title"] as String).tr(context),
                        style: Styles.semibold14Primary(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
