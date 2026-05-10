import '../imports/imports.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    cardColor: AppColors.white,
    shadowColor: AppColors.grey.withOpacity(.5),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      color: AppColors.textColor,
    )),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(.4),
      selectionHandleColor: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.strokColor,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.red[900] ?? Colors.red,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.red[900],
        fontSize: 12,
      ),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    cardColor: const Color(0xff353535),
    scaffoldBackgroundColor: const Color(0xff262626),
    shadowColor: AppColors.black.withOpacity(.15),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      color: AppColors.white,
    )),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(.4),
      selectionHandleColor: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xff353535),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.red[900] ?? Colors.red,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.red[900],
        fontSize: 12,
      ),
    ),
  );
}
