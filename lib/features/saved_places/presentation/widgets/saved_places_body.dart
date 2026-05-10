import '../../../../core/imports/imports.dart';
import 'add_saved_place_alert_dialog.dart';
import 'saved_places_list_view.dart';

class SavedPlacesBody extends StatelessWidget {
  const SavedPlacesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  //! Header
                  CustomAppBar(
                    title: AppStrings.savedPlaces.tr(context),
                  ),

                  SizedBox(height: 16.rH(context)),

                  //! List View
                  const SavedPlacesListView(),
                ],
              ),
            ),

            //! Add Button
            PositionedDirectional(
              bottom: 65.rH(context),
              end: 0,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddSavedPlaceAlertDialog(),
                  ).then((value) {
                    if (value == true) {
                      context.read<SavedPlacesCubit>().getSavedLocations();
                    }
                  });
                },
                child: Container(
                  width: 60.rH(context),
                  height: 60.rH(context),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 28.rH(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
