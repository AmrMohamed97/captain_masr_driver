import 'package:dio/dio.dart';

import '../../../app/app.dart';
import '../../imports/imports.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = sl<Cache>().getStringData(AppConstants.token);
    options.headers["Authorization"] = token != null ? 'Bearer $token' : null;
    options.headers["Accept-Language"] = sl<Cache>().getLanguage();
    options.headers["Accept"] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Print.success(response.headers.map[ApiKey.authorization]);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            context.read<GlobalCubit>().selectRole(AppConstants.driver);
            // context
            //               .read<GlobalCubit>()
            //               .selectRole(AppConstants.rider);
            return const LoginView();
          },
        ),
        (route) => false,
      );
      // AppRouter.router.go(AppRoutes.login);
    }
    super.onError(err, handler);
  }
}
