import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/become_rider_or_driver/data/repo/become_rider_or_driver_repo.dart';
import '../../features/chat/data/repo/chat_repo.dart';
import '../../features/delivery/data/repo/delivery_repo.dart';
import '../../features/driver_share_trip/data/repo/driver_share_trip_repo.dart';
import '../../features/driver_trip/data/repo/driver_trip_repo.dart';
import '../../features/earnings/data/repo/earnings_repo.dart';
import '../../features/forget_password/data/password_repo.dart';
import '../../features/home/data/repo/home_repo.dart';
import '../../features/login/data/repo/login_repo.dart';
import '../../features/my_vehicle/data/repo/vehicle_repo.dart';
import '../../features/notifications/data/repo/notifications_repo.dart';
import '../../features/otp/data/repo/otp_repo.dart';
import '../../features/preferences/data/repo/preferences_repo.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/promo_code/data/repo/promo_codes_repo.dart';
import '../../features/rating/data/repo/rating_repo.dart';
import '../../features/register/data/repo/register_repo.dart';
import '../../features/rider_share_trip/data/repo/rider_share_trip_repo.dart';
import '../../features/rider_trip/data/repo/rider_trip_repo.dart';
import '../../features/saved_places/data/repo/saved_places_repo.dart';
import '../../features/learning/data/repo/learning_repo.dart';
import '../../features/schedule_trip/data/repo/schedule_trip_repo.dart';
import '../../features/trip_details/data/repo/trip_details_repo.dart';
import '../../features/trips/data/repo/trips_repo.dart';
import '../../features/wallet/data/repo/wallet_repo.dart';
import '../databases/api/dio_consumer.dart';
import '../databases/cache/cache.dart';

final sl = GetIt.instance;
void initServiceLocator() {
  sl.registerLazySingleton(() => Cache());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));

  //! Repositories
  sl.registerLazySingleton(() => LoginRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => OtpRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => PasswordRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ProfileRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => VehicleRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => PreferencesRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => SavedPlacesRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => HomeRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RiderTripRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RiderShareTripRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => DriverTripRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => DriverShareTripRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RatingRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ChatRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => DeliveryRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => EarningsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => WalletRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => TripsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => TripDetailsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => NotificationsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => BecomeRiderOrDriverRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => PromoCodesRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ScheduleTripRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => LearningRepo(sl<DioConsumer>()));
}
