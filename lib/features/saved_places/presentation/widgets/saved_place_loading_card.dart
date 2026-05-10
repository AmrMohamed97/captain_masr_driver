import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class SavedPlaceLoadingCard extends StatelessWidget {
  const SavedPlaceLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.rW(context),
        vertical: 13.rH(context),
      ),
      margin: EdgeInsets.only(bottom: 16.rH(context)),
      decoration: BoxDecoration(
        color: context.read<GlobalCubit>().isDarkMode
            ? Theme.of(context).cardColor
            : AppColors.grey3,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomShimmer(
                h: 20.rH(context),
                w: 20.rW(context),
                borderRadius: 8,
              ),
              SizedBox(width: 8.rW(context)),
              CustomShimmer(
                h: 14.rH(context),
                w: 100.rW(context),
                borderRadius: 8,
              ),
            ],
          ),
          SizedBox(height: 8.rH(context)),
          CustomShimmer(
            h: 14.rH(context),
            w: 200.rW(context),
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}
