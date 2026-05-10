import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import 'add_saved_place_alert_dialog.dart';
import 'delete_saved_location_alert_dialog.dart';
import 'saved_place_card.dart';
import 'saved_place_loading_card.dart';

class SavedPlacesListView extends StatelessWidget {
  const SavedPlacesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
      builder: (context, state) {
        final cubit = context.read<SavedPlacesCubit>();
        return Expanded(
          child: CustomRefreshIndicator(
            onRefresh: () {
              return cubit.getSavedLocations();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: 16.rH(context),
                bottom: 130.rH(context),
              ),
              itemCount: state is GetSavedLocationLoadingState
                  ? 5
                  : cubit.savedLocations.length,
              itemBuilder: (context, index) {
                if (state is GetSavedLocationLoadingState) {
                  return const SavedPlaceLoadingCard();
                }
                return SavedPlaceCard(
                  model: cubit.savedLocations[index],
                  onTap: () {
                    if (cubit.canChoose) {
                      Navigator.pop(context, cubit.savedLocations[index]);
                    }
                  },
                  editOnTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddSavedPlaceAlertDialog(
                        isEdit: true,
                        model: cubit.savedLocations[index],
                      ),
                    ).then((value) {
                      if (value == true) {
                        cubit.getSavedLocations();
                      }
                    });
                  },
                  deleteOnTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const DeleteSavedLocationAlertDialog(),
                    ).then((value) {
                      if (value == true) {
                        cubit.deleteLocation(index);
                      }
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
