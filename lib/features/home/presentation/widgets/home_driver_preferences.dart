import '../../../../core/imports/imports.dart';
import '../../data/models/services_model.dart';
import '../cubit/home_cubit.dart';
import 'home_driver_preferences_card.dart';

class HomeDriverPreferences extends StatelessWidget {
  const HomeDriverPreferences({super.key});

  static List preferences = [
    ServicesModel(
      title: AppStrings.privateAndComfy,
      type: AppStrings.classicRide,
      image: Assets.imagesClassicTripCard,
    ),
    ServicesModel(
      title: AppStrings.saveAndShare,
      type: AppStrings.shareRide,
      image: Assets.imagesShareTripCard,
    ),
    ServicesModel(
      title: AppStrings.rideTogether,
      type: AppStrings.groupRide,
      image: Assets.imagesGroupTripCard,
    ),
    ServicesModel(
      title: AppStrings.fastAndReliable,
      type: AppStrings.delivery,
      image: Assets.imagesDeliveryPng,
    ),
    ServicesModel(
      title: AppStrings.racing,
      type: AppStrings.racing,
      image: Assets.imagesRacingTripCard,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! Title
          // Text(
          //   AppStrings.preferences.tr(context),
          //   style: Styles.semibold18Primary(
          //     context,
          //   ).copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
          // ),
          SizedBox(height: 25.rH(context)),

          //! Grid View
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = context.read<HomeCubit>();

              // hide grid until trip types are loaded from API
              if (cubit.driverTripTypes.isEmpty) return const SizedBox.shrink();

              // filter only the preferences that are active
              final filteredPreferences = preferences
                  .asMap()
                  .entries
                  .where(
                    (e) =>
                        cubit.driverTripTypes.contains(e.key + 1) || e.key == 4,
                  )
                  .toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.rH(context),
                  crossAxisSpacing: 16.rW(context),
                  mainAxisExtent: 143.rH(context),
                ),
                itemCount: filteredPreferences.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final entry = filteredPreferences[index];
                  return HomeDriverPreferencesCard(
                    model: entry.value,
                    onTap: () => cubit.preferencesToggle(entry.key),
                    active: cubit.checkPreferencesActive(entry.key),
                    index: entry.key,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
