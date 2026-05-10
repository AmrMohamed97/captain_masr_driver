import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_dashed_container.dart';
import 'choose_location_field_helper.dart';

class ChooseLocatioFields extends StatelessWidget {
  const ChooseLocatioFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
      builder: (context, state) {
        final cubit = context.read<ChooseLocationCubit>();
        return Stack(
          children: [
            PositionedDirectional(
              start: 10.rW(context),
              top: 12.rH(context),
              bottom: 12.rH(context),
              child: CustomDashedContainer(
                dashWidth: 8.rH(context),
                color: AppColors.primary,
                child: Container(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //! Start Location
                if (cubit.selectionMode == SelectionMode.pickup)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.rH(context)),
                      Container(
                        height: 45.rH(context),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: CustomSvgPicture(
                            svg: Assets.imagesPinLocation,
                            width: 20.rW(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.rW(context)),
                      Expanded(
                        child: CustomTextField(
                          controller: cubit.startLocationController,
                          hintText: AppStrings.chooseStartLocation.tr(context),
                          helper: cubit.selectedIndex == 0
                              ? const ChooseLocationFieldHelper()
                              : null,
                          onTap: () {
                            cubit.selectIndexToggle(0);
                            cubit.clearSuggestions();
                          },
                          borderColor:
                              cubit.selectedIndex == 0 ? AppColors.primary : null,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 13.rH(context),
                            horizontal: 8.rW(context),
                          ),
                          onChanged: (value) {
                            (state is! GetSuggestionsLoadingState)
                                ? cubit.getSuggestions(
                                    cubit.startLocationController.text)
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                if (cubit.selectionMode == SelectionMode.destination)
                  Column(
                    children: [
                      //! Stops
                      ...List.generate(
                        cubit.stops.length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 16.rH(context),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45.rH(context),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Center(
                                    child: CustomSvgPicture(
                                      svg: Assets.imagesEndLocationPin,
                                      width: 20.rW(context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.rW(context)),
                                Expanded(
                                  child: CustomTextField(
                                    controller: cubit.stopsControllers[index],
                                    hintText: AppStrings.chooseYourDestination
                                        .tr(context),
                                    helper: index + 2 == cubit.selectedIndex
                                        ? const ChooseLocationFieldHelper()
                                        : null,
                                    onChanged: (value) {
                                      (state is! GetSuggestionsLoadingState)
                                          ? cubit.getSuggestions(cubit
                                              .stopsControllers[index].text)
                                          : null;
                                    },
                                    onTap: () {
                                      cubit.selectIndexToggle(index + 2);
                                      cubit.clearSuggestions();
                                    },
                                    borderColor: index + 2 == cubit.selectedIndex
                                        ? AppColors.primary
                                        : null,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 13.rH(context),
                                      horizontal: 8.rW(context),
                                    ),
                                    suffixIcon: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => cubit.removeStop(index),
                                          child: Container(
                                            width: 22.rW(context),
                                            height: 22.rH(context),
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.red.withOpacity(.5),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                              size: 16.rH(context),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      //! End Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 45.rH(context),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Center(
                              child: CustomSvgPicture(
                                svg: Assets.imagesEndLocationPin,
                                width: 20.rW(context),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.rW(context)),
                          Expanded(
                            child: CustomTextField(
                              controller: cubit.endLocationController,
                              hintText:
                                  AppStrings.chooseYourDestination.tr(context),
                              onChanged: (value) {
                                (state is! GetSuggestionsLoadingState)
                                    ? cubit.getSuggestions(
                                        cubit.endLocationController.text)
                                    : null;
                              },
                              helper: cubit.selectedIndex == 1
                                  ? const ChooseLocationFieldHelper()
                                  : null,
                              onTap: () {
                                cubit.selectIndexToggle(1);
                                cubit.clearSuggestions();
                              },
                              borderColor: cubit.selectedIndex == 1
                                  ? AppColors.primary
                                  : null,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 13.rH(context),
                                horizontal: 8.rW(context),
                              ),
                              suffixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => cubit.addStop(),
                                    child: Container(
                                      width: 22.rW(context),
                                      height: 22.rH(context),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey2.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                        size: 16.rH(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
