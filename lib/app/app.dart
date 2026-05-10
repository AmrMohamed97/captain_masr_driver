import 'package:flutter/services.dart';

import '../core/imports/imports.dart';
import '../core/local/localization_settings.dart';
import '../core/theme/theme.dart';
import '../core/widgets/custom_toast.dart';
import '../features/splash/presentation/views/splash_view.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CaptainMasrDriver extends StatelessWidget {
  const CaptainMasrDriver({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final globalCubit = context.read<GlobalCubit>();
        return MaterialApp(
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          localizationsDelegates: localizationsDelegatesList,
          supportedLocales: supportedLocalesList,
          locale: Locale(globalCubit.language),
          home: BlocConsumer<GlobalCubit, GlobalState>(
            listener: (context, state) {
              if (state is UpdateUserDataErrorState) {
                showToast(
                  context,
                  message: state.error,
                  state: ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              return const SplashView();
            },
          ),
          //!Theme
          theme: globalCubit.isDarkMode ? darkTheme() : theme(),
          //! Scroll Behavior
          scrollBehavior: const ScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
        );
      },
    );
  }
}
