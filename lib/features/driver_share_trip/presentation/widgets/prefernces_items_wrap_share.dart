import '../../../../core/imports/imports.dart';
import '../../../preferences/data/models/preferences_model.dart';

class PreferencesItemsWrapShare extends StatelessWidget {
  const PreferencesItemsWrapShare({
    super.key,
    required this.preferences,
  });

  final PreferencesModel preferences;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(
        4,
        (index) {
          return (preferences.coolRide != true && index == 0) ||
                  (preferences.quietRide != true && index == 1) ||
                  (preferences.smokingFriendly != true && index == 2) ||
                  (preferences.petsFree != true && index == 3)
              ? const SizedBox.shrink()
              : Container(
                  width: 22.rW(context),
                  height: 22.rH(context),
                  margin: EdgeInsetsDirectional.only(
                    end: 5.rW(context),
                    top: 4.rH(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey3.withOpacity(.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 16.rH(context),
                      width: 16.rW(context),
                      child: CustomSvgPicture(
                        svg: (switch (index) {
                          0 => Assets.imagesAirConditioner,
                          1 => Assets.imagesMusic,
                          2 => Assets.imagesSmoking,
                          3 => Assets.imagesPets,
                          _ => "",
                        }),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
