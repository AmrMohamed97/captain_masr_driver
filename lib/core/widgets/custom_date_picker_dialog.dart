import '../imports/imports.dart';

Future<DateTime?> customDatePickerDialog(
  BuildContext context, {
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Theme.of(context).textTheme.bodyLarge!.color!,
            onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
          ),
          useMaterial3: false,
          dialogTheme: DialogThemeData(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
              Styles.medium15(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            )),
          ),
        ),
        child: child!,
      );
    },
  );
}
