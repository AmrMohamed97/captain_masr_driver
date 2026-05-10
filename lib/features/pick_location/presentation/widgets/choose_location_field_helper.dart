import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../data/models/selected_location_model.dart';
import '../views/pick_location_view.dart';
import 'choose_location_saved_locations.dart';

class ChooseLocationFieldHelper extends StatelessWidget {
  const ChooseLocationFieldHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
      builder: (context, state) {
        final cubit = context.read<ChooseLocationCubit>();
        return Column(
          children: [
            //! Icons
            const ChooseLocationSavedLocations(),

            SizedBox(height: 16.rH(context)),

            //! Choose Location On Map Button
            GestureDetector(
              onTap: () {
                navigate(
                  context,
                  const PickLocationView(),
                  then: (value) {
                    if (value != null && value is List) {
                      cubit.selectLocation(
                          model: SelectedLocationModel(
                        address: value[1],
                        lat: (value[0] as CameraPosition).target.latitude,
                        lon: (value[0]).target.longitude,
                      ));
                    }
                  },
                );
              },
              child: Row(
                children: [
                  CustomSvgPicture(
                    svg: Assets.imagesPinEllipse,
                    height: 18.rH(context),
                  ),
                  SizedBox(width: 8.rH(context)),
                  Text(
                    AppStrings.chooseLocationOnMap.tr(context),
                    style: Styles.regular14(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.rH(context)),

            //! Suggestions
            ...List.generate(
              state is GetSuggestionsLoadingState
                  ? 3
                  : cubit.suggestions.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(top: 16.rH(context)),
                  child: state is GetSuggestionsLoadingState
                      ? CustomShimmer(
                          w: double.infinity,
                          h: 19.rH(context),
                          borderRadius: 8,
                        )
                      : GestureDetector(
                          onTap: () async {
                            final suggestion = cubit.suggestions[index];
                            await cubit.fetchPlaceDetails(
                              placeId: suggestion["place_id"],
                              description: suggestion["description"],
                            );
                            cubit.getSuggestions(
                                suggestion["description"].toString());
                          },
                          child: Row(
                            children: [
                              CustomSvgPicture(
                                svg: Assets.imagesPinLocation,
                                color: AppColors.grey,
                                height: 18.rH(context),
                              ),
                              SizedBox(width: 6.rW(context)),
                              Expanded(
                                child: Text(
                                  cubit.suggestions[index]["description"]
                                      .toString(),
                                  style: Styles.regular14(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),

            //! Recent Locations
            ...List.generate(
              cubit.recentLocations.length,
              (index) {
                if (cubit.recentLocations[index].address == null) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.only(top: 16.rH(context)),
                  child: GestureDetector(
                    onTap: () {
                      cubit.selectLocation(model: cubit.recentLocations[index]);
                      cubit.getSuggestions(
                        cubit.recentLocations[index].address ?? "",
                      );
                    },
                    child: Row(
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesTime,
                          color: AppColors.grey,
                          height: 18.rH(context),
                        ),
                        SizedBox(width: 6.rW(context)),
                        Expanded(
                          child: Text(
                            cubit.recentLocations[index].address!,
                            style: Styles.regular14(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 8.rH(context)),

            //! Divider
            Divider(
              color: AppColors.greyText.withOpacity(.5),
              endIndent: 0,
            ),
          ],
        );
      },
    );
  }
}
