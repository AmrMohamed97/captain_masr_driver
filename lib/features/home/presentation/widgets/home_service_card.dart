import '../../../../core/imports/imports.dart';
import '../../data/models/services_model.dart';

class HomeServiceCard extends StatelessWidget {
  const HomeServiceCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.selected,
    required this.index,
  });

  final ServicesModel model;
  final Function() onTap;
  final bool selected;
  final int index;

  String _getServiceType(BuildContext context) {
    final language = context.read<GlobalCubit>().language;
    if (language == "ar") {
      switch (model.type) {
        case AppStrings.shareRide:
          return "في طريقي";
        case AppStrings.dailyRides:
          return "جدولة الرحلة";
        case AppStrings.classicRide:
          return "الرحلة الخاصة";
        case AppStrings.delivery:
          return "التوصيل";
        case AppStrings.race:
          return "السباق";
        default:
          return model.type.tr(context);
      }
    } else {
      switch (model.type) {
        case AppStrings.shareRide:
          return "On my way";
        case AppStrings.dailyRides:
          return "Schedule trip";
        case AppStrings.classicRide:
          return "Classic Ride";
        case AppStrings.delivery:
          return "Delivery";
        case AppStrings.race:
          return "Race";
        default:
          return model.type.tr(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: selected ? 1.0 : 0.95,
        child: Container(
          width: 116.rW(context),
          height: 118.rH(context),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.rW(context)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.04),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.rW(context),
            vertical: 12.rH(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //! Image
              Expanded(
                child: Image.asset(
                  model.image,
                  height: 60.rH(context),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8.rH(context)),
              //! Title
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _getServiceType(context),
                  textAlign: TextAlign.center,
                  style: Styles.semibold14Primary(context).copyWith(
                    color:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.rT(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
