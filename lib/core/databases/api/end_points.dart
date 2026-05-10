class EndPoints {
  static const String baseUrl = "https://ma3ak.evyx.lol/api/";
  //! Login
  static const String userLogin = "${baseUrl}user/login";
  static const String driverLogin = "${baseUrl}driver/login";

  //! Register
  static const String userRegister = "${baseUrl}user/register";
  static const String driverRegister = "${baseUrl}driver/register";

  //! Otp
  static const String userVerifyOtp = "${baseUrl}user/verify-otp";
  static const String checkOtp = "${baseUrl}user/check-otp";
  static const String resendOtp = "${baseUrl}user/resend-otp";
  static const String verifyEmail = "${baseUrl}user/verify-change-email";
  static const String userEmailResendOtp = "${baseUrl}user/resend-otp-email";
  static const String driverEmailResendOtp =
      "${baseUrl}driver/resend-otp-email";
  static const String verifyChangePhone = "${baseUrl}user/verify-change-phone";

  //! Show Profile
  static const String userProfile = "${baseUrl}user/profile";
  static const String driverProfile = "${baseUrl}driver/profile";

  //! Forget Password
  static const String userForgetPassword = "${baseUrl}user/forget-password";
  //! Reset Password
  static const String userResetPassword = "${baseUrl}user/reset-password";

  //! Edit Profile
  static const String userUpdateProfile = "${baseUrl}user/update-profile";
  static const String updatePhone = "${baseUrl}user/update-phone";
  static const String updateEmail = "${baseUrl}user/update-email";

  //! Delete Account
  static const String deleteAccount = "${baseUrl}user/delete-account";

  //! Vehicle
  static const String driverVehicle = "${baseUrl}driver/my-vehicle";
  static const String updateDriverVehicle = "${baseUrl}driver/vehicle/store";
  static const String vehicleCategories = "${baseUrl}vehicle-categories";
  static const String vehicleTypes = "${baseUrl}vehicle-types";
  static const String vehicleBrands = "${baseUrl}vehicle-brands";
  static const String vehicleModels = "${baseUrl}vehicle-models";
  static const String vehicleColors = "${baseUrl}vehicle-colors";
  static const String tripVehicleCategories =
      "${baseUrl}vehicle-categories/by-trip-type";
  static const String seats = "${baseUrl}seets/all";

  //! Preferences
  static const String preferences = "${baseUrl}user/preferences";
  static const String driverPreferences = "${baseUrl}driver/preferences";

  //! Saved Places
  static const String savedLocations = "${baseUrl}user/savedLocations";

  //! Change Password
  static const String changePassword = "${baseUrl}user/change-password";

  //! Rider Trips
  static const String userRequestClassic = "${baseUrl}user/request/classic";
  static const String userAcceptDriver = "${baseUrl}user/request/accept-driver";
  static const String userTripEstimate =
      "${baseUrl}user/request/estimate-classic";
  static const String cancelTrip = "${baseUrl}rides/tripId/cancel";
  static const String riderRateTrip = "${baseUrl}user/request/ID/rate";
  static const String deliverItems = "${baseUrl}deliver-items";
  static const String deliverItemsSizes = "${baseUrl}deliver-item-sizes";
  static const String riderSearchShareRides =
      "${baseUrl}user/share-trips/search";
  static const String riderRequestShareTrip =
      "${baseUrl}user/share-trips/request-share-ride";
  static const String riderCancelShareTrip =
      "${baseUrl}user/share-trips/cancel";
  static const String removeAssignedForDriver =
      "${baseUrl}user/request/remove-assigned-ride";

  //! Driver Trips
  static const String driverAcceptRide = "${baseUrl}driver/request/classic";
  static const String driverArrived = "${baseUrl}driver/request/ID/arrived";
  static const String driverStartTrip = "${baseUrl}driver/request/ID/start";
  static const String driverCompleteTrip =
      "${baseUrl}driver/request/ID/complete";
  static const String driverTripTypes = "${baseUrl}driver/trip-types";
  static const String driverPostShareTrip =
      "${baseUrl}driver/share-trips/store";
  static const String driverCompleteShareTrip =
      "${baseUrl}driver/share-trips/complete";
  static const driverAcceptShareTripRider =
      "${baseUrl}driver/share-trips/accept";
  static const driverArrivedShareTrip = "${baseUrl}driver/share-trips/arrived";
  static const driverCompleteShareTripWithRiders =
      "${baseUrl}driver/share-trips/complete-with-riders";
  static const driverStartShareTrip = "${baseUrl}driver/share-trips/start";
  static const driverStartShareTripWithRiders =
      "${baseUrl}driver/share-trips/start-with-riders";
  static const driverCancelShareTripWithRiders =
      "${baseUrl}driver/share-trips/cancel";
  static const driverCancelShareTripWithoutRiders =
      "${baseUrl}driver/share-trips/cancel-without-riders";
  static const driverCancelShareTrip = "${baseUrl}driver/share-trips/cancel";

  //! Chat
  static const String getChat = "${baseUrl}chat/get-ride-chats";
  static const String sendMessage = "${baseUrl}chat/send-message";

  //! Summary
  static const String driverSummary = "${baseUrl}driver/trips-summary";
  static const String driverTodaySummary = "${baseUrl}driver/trips/today";

  //! Wallet
  static const String userTransactions = "${baseUrl}user/transactions";
  static const String driverTransactions = "${baseUrl}driver/transactions";

  //! Trips History
  static const String userCompletedTrips = "${baseUrl}user/completed-trips";
  static const String userCanceledTrips = "${baseUrl}user/canceled-trips";
  static const String driverCompletedTrips = "${baseUrl}driver/completed-trips";
  static const String driverCanceledTrips = "${baseUrl}driver/canceled-trips";

  //! Sliders
  static const String sliders = "${baseUrl}sliders";

  //! Notifications
  static const String notifications = "${baseUrl}notifications";

  //! Switch Flow
  static const String becomeDriver = "${baseUrl}user/become-driver";
  static const String becomeRider = "${baseUrl}driver/become-rider";

  //! Promo Codes
  static const String promoCodes = "${baseUrl}user/promo-codes";

  //! Payment Methods
  static const String paymentMethods = "${baseUrl}payment-methods";
  static const String setDefaultPaymentMethod =
      "${baseUrl}user/set-default-payment-method";

  //! Schedule Trip
  static const String driverPostScheduleTrip =
      "${baseUrl}driver/share-trips/schedule-multiple";
  static const String userRequestScheduledTrip =
      "${baseUrl}user/share-trips/request-share-ride-multi";
  static const String getUserScheduleTrips =
      "${baseUrl}user/my-scheduled-share-trips";
  static const String getDriverScheduleTrips =
      "${baseUrl}driver/share-trips/my-trips";
  static const String riderSearchScheduledTrips =
      "${baseUrl}user/share-trips/multi/search";
  static const String driverCancelAllScheduleTrip =
      "${baseUrl}driver/share-trips/cancel-all";
  static const String driverCancelScheduleTripForRider =
      "${baseUrl}driver/share-trips/cancel-request";

  //! Learning
  static const String getLearningUrl = "${baseUrl}pages/get-url/learning";

  //! Support
  static const String sendMessageToAdmin = "${baseUrl}user/messages";
}
