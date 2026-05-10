import '../../../../core/imports/imports.dart';
import '../widgets/preferences_body.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({
    super.key,
    this.isEdit = false,
  });

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreferencesCubit()
        ..isEdit = isEdit
        ..getPreferences(),
      child: Scaffold(
        body: BlocBuilder<PreferencesCubit, PreferencesState>(
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is GetPreferencesLoadingState ||
                  state is SavePreferencesLoadingState,
              child: const PreferencesBody(),
            );
          },
        ),
      ),
    );
  }
}
