import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui';

import 'app_loacl.dart';

var localizationsDelegatesList = [
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  AppLocalizations.delegate,
];

//  supportedLocalesList
const supportedLocalesList = [
  Locale('ar', "EG"),
  Locale('en', "US"),
];
