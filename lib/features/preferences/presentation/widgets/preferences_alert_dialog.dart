import '../../../../core/imports/imports.dart';
import '../../data/models/preferences_model.dart';
import 'preferences_body.dart';

class PreferencesAlertDialog extends StatelessWidget {
  const PreferencesAlertDialog({
    super.key,
    this.canEdit = false,
    this.showCantEditTitle = true,
    this.preferencesModel,
    this.getPreferences = false,
  });

  final bool canEdit, showCantEditTitle, getPreferences;
  final PreferencesModel? preferencesModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreferencesCubit()
        ..airConditioner = preferencesModel?.coolRide ?? false
        ..quiet = preferencesModel?.quietRide ?? false
        ..smoking = preferencesModel?.smokingFriendly ?? false
        ..pets = preferencesModel?.petsFree ?? false
        ..canEdit = canEdit
        ..init(getPreferences),
      child: BlocBuilder<PreferencesCubit, PreferencesState>(
        builder: (context, state) {
          return CustomModalProgressIndicator(
            inAsyncCall: state is GetPreferencesLoadingState ||
                state is SavePreferencesLoadingState,
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              elevation: 0,
              content: Container(
                width: 344.rW(context),
                padding: EdgeInsets.symmetric(
                  vertical: 27.rH(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PreferencesBody(
                  isDialog: true,
                  showCantEditTitle: showCantEditTitle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
