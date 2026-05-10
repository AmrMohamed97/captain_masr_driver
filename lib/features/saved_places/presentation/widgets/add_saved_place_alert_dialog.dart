import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../pick_location/presentation/views/pick_location_view.dart';
import '../../data/models/saved_place_model.dart';

class AddSavedPlaceAlertDialog extends StatelessWidget {
  const AddSavedPlaceAlertDialog({
    super.key,
    this.isEdit = false,
    this.model,
  });

  final bool isEdit;
  final SavedPlaceModel? model;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedPlacesCubit()..initEdit(model),
      child: BlocConsumer<SavedPlacesCubit, SavedPlacesState>(
        listener: (context, state) {
          if (state is SaveLocationSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            Navigator.pop(context, true);
          }
          if (state is SaveLocationErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<SavedPlacesCubit>();
          return CustomModalProgressIndicator(
            inAsyncCall: state is SaveLocationLoadingState,
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              elevation: 0,
              content: Container(
                width: 343.rW(context),
                padding: EdgeInsets.symmetric(
                  vertical: 24.rH(context),
                  horizontal: 16.rW(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //! Title
                      Text(
                        isEdit
                            ? AppStrings.editPlace.tr(context)
                            : AppStrings.addPlace.tr(context),
                        style: Styles.semibold21Primary(context),
                      ),

                      SizedBox(height: 10.rH(context)),

                      //! Form
                      Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            //! Place Name
                            AuthTextField(
                              controller: cubit.placeNameController,
                              title: AppStrings.placeName.tr(context),
                              hintText: AppStrings.enterPlaceName.tr(context),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppStrings.enterPlaceName.tr(context);
                                }
                                return null;
                              },
                            ),
                            //! Place Location
                            GestureDetector(
                              onTap: () {
                                navigate(
                                  context,
                                  const PickLocationView(),
                                  then: (value) {
                                    if (value != null &&
                                        value is List &&
                                        value[0] is CameraPosition) {
                                      cubit
                                          .placeLocationController.text = value[
                                              1] ??
                                          "${value[0].target.latitude}, ${value[0].target.longitude}";
                                      cubit.lat = (value[0] as CameraPosition)
                                          .target
                                          .latitude;
                                      cubit.long = (value[0] as CameraPosition)
                                          .target
                                          .longitude;
                                    }
                                  },
                                );
                              },
                              child: AuthTextField(
                                enabled: false,
                                controller: cubit.placeLocationController,
                                title: AppStrings.placeLocation.tr(context),
                                hintText:
                                    AppStrings.enterPlaceLocation.tr(context),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppStrings.enterPlaceLocation
                                        .tr(context);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //! Icons
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                AppStrings.chooseIcon.tr(context),
                                style: Styles.regular14(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                            ),
                            SizedBox(height: 6.rH(context)),
                            SizedBox(
                              height: 38.rH(context),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                    cubit.svgIcons.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          cubit.selectIcon(index);
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: 38.rH(context),
                                          height: 38.rH(context),
                                          margin: EdgeInsetsDirectional.only(
                                            end: 10.rW(context),
                                          ),
                                          decoration: BoxDecoration(
                                            color: context
                                                    .read<GlobalCubit>()
                                                    .isDarkMode
                                                ? Theme.of(context).cardColor
                                                : AppColors.grey4,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              width: 2,
                                              color: cubit.selectedIconIndex ==
                                                      index
                                                  ? AppColors.primary
                                                  : AppColors.transparent,
                                            ),
                                          ),
                                          child: Center(
                                            child: CustomSvgPicture(
                                              svg: cubit.svgIcons[index],
                                              height: 21.rH(context),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 22.rH(context)),

                            //! Save Button
                            CustomButton(
                              onPressed: () {
                                if (cubit.formKey.currentState!.validate() &&
                                    cubit.lat != null &&
                                    cubit.long != null) {
                                  isEdit
                                      ? cubit.editLocation(id: model?.id ?? 0)
                                      : cubit.saveLocation();
                                }
                              },
                              title: AppStrings.savePlace.tr(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
