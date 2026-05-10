import '../../../../core/imports/imports.dart';

class SelectLuggagesNumberContainer extends StatelessWidget {
  const SelectLuggagesNumberContainer({
    super.key,
    required this.smallValue,
    required this.mediumValue,
    required this.largeValue,
    required this.increaseOnTap,
    required this.decreaseOnTap,
  });

  final int smallValue, mediumValue, largeValue;
  final Function(int) increaseOnTap, decreaseOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.rW(context),
        vertical: 8.rH(context),
      ),
      margin: EdgeInsets.only(top: 8.rH(context)),
      decoration: BoxDecoration(
        // color: AppColors.grey.withOpacity(.25),
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Container(
              decoration: index == 1
                  ? const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: AppColors.grey,
                        ),
                        right: BorderSide(
                          color: AppColors.grey,
                        ),
                      ),
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (switch (index) {
                      0 => AppStrings.small.tr(context),
                      1 => AppStrings.medium.tr(context),
                      2 => AppStrings.large.tr(context),
                      _ => "",
                    }),
                    style: Styles.regular14(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 8.rH(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //! Decrease Buton
                      GestureDetector(
                        onTap: () => (smallValue == 0 && index == 0) ||
                                (mediumValue == 0 && index == 1) ||
                                (largeValue == 0 && index == 2)
                            ? null
                            : decreaseOnTap(index),
                        child: CircleAvatar(
                          radius: 10.rH(context),
                          backgroundColor: (smallValue == 0 && index == 0) ||
                                  (mediumValue == 0 && index == 1) ||
                                  (largeValue == 0 && index == 2)
                              ? AppColors.greyText.withOpacity(.5)
                              : AppColors.primary,
                          child: Icon(
                            Icons.remove,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 14.rH(context),
                          ),
                        ),
                      ),
                      //! Value
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.rW(context),
                        ),
                        child: Text(
                          (switch (index) {
                            0 => "$smallValue",
                            1 => "$mediumValue",
                            2 => "$largeValue",
                            _ => "0",
                          }),
                          style: Styles.medium16Primary(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      //! Increase Buton
                      GestureDetector(
                        onTap: () => increaseOnTap(index),
                        child: CircleAvatar(
                          radius: 10.rH(context),
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 14.rH(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
