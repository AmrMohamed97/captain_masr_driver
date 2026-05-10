import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import 'preferences_switch_card.dart';
import 'rider_register_congratulation_alert_dialog.dart';

class PreferencesBody extends StatelessWidget {
  const PreferencesBody({
    super.key,
    this.isDialog = false,
    this.showCantEditTitle = true,
  });

  final bool isDialog, showCantEditTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        final cubit = context.read<PreferencesCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.rW(context)),
          child: Column(
            mainAxisSize: isDialog ? MainAxisSize.min : MainAxisSize.max,
            children: [
              //! Header
              if (!isDialog)
                CustomAppBar(
                  title: AppStrings.preferences.tr(context),
                ),

              if (isDialog)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 18.rW(context),
                    ),
                    Text(
                      AppStrings.preferences.tr(context),
                      style: Styles.semibold18Primary(context),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),

              SizedBox(height: isDialog ? 25.rH(context) : 53.rH(context)),

              //! Air Conditioner
              PreferencesSwitchCard(
                title: AppStrings.airConditioner.tr(context),
                svg: Assets.imagesAirConditioner,
                value: cubit.airConditioner,
                onTap: (value) {
                  if (cubit.canEdit) {
                    cubit.airConditioner = value;
                    cubit.switchToggle();
                  }
                },
              ),
              //! Music
              PreferencesSwitchCard(
                title: AppStrings.quietRide.tr(context),
                svg: Assets.imagesMusicOff,
                value: cubit.quiet,
                onTap: (value) {
                  if (cubit.canEdit) {
                    cubit.quiet = value;
                    cubit.switchToggle();
                  }
                },
              ),
              //! Smoking
              PreferencesSwitchCard(
                title: AppStrings.smoking.tr(context),
                svg: Assets.imagesSmoking,
                value: cubit.smoking,
                onTap: (value) {
                  if (cubit.canEdit) {
                    cubit.smoking = value;
                    cubit.switchToggle();
                  }
                },
              ),
              //! Pets
              PreferencesSwitchCard(
                title: AppStrings.pets.tr(context),
                svg: Assets.imagesPets,
                value: cubit.pets,
                onTap: (value) {
                  if (cubit.canEdit) {
                    cubit.pets = value;
                    cubit.switchToggle();
                  }
                },
              ),

              SizedBox(
                  height: !cubit.canEdit
                      ? showCantEditTitle
                          ? 30.rH(context)
                          : 0
                      : isDialog
                          ? 56.rH(context)
                          : 16.rH(context)),

              //! Confirm Button
              if (cubit.canEdit)
                BlocConsumer<PreferencesCubit, PreferencesState>(
                  listener: (context, state) {
                    if (state is SavePreferencesSuccessState) {
                      showToast(
                        context,
                        message: state.message,
                        state: ToastStates.success,
                      );
                      if (cubit.isEdit) {
                        Navigator.pop(context);
                      } else if (isDialog) {
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const RiderRegisterCongratulationAlertDialog(),
                        );
                      }
                    }
                    if (state is SavePreferencesErrorState) {
                      showToast(
                        context,
                        message: state.error,
                        state: ToastStates.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      onPressed: () {
                        cubit.savePreferences();
                      },
                      title: isDialog
                          ? AppStrings.saveChanges.tr(context)
                          : AppStrings.confirm.tr(context),
                    );
                  },
                ),

              if (!cubit.canEdit && showCantEditTitle)
                Text(
                  AppStrings.preferencesCannotBeUpdatedDuringAnActiveTrip
                      .tr(context),
                  style: Styles.medium12(context).copyWith(
                    color: AppColors.red,
                  ),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }
}
