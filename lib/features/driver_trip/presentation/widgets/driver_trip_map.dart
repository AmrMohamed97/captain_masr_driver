import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../cubit/driver_trip_cubit.dart';

/* 
// فى هذه الصفحة يمكن وضع شرط 
// if (cubit.isTripStarted)
// لو هذا الشرط تحقق معناه ان الرحلة بدأ وبناء عليه اخلى رسم الخط على الخريطة متغير مع الحركة
*/
class DriverTripMap extends StatefulWidget {
  const DriverTripMap({super.key});

  @override
  State<DriverTripMap> createState() => _DriverTripMapState();
}

class _DriverTripMapState extends State<DriverTripMap> {
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    final driverCubit = context.read<DriverTripCubit>();

    if (!driverCubit.tripEnded) {
      // شغل التايمر حتى لو كان الموقع null مؤقتاً، سيلتقطه لاحقاً
      _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (driverCubit.tripEnded) {
          driverCubit.getRoute();
          timer.cancel(); // 🔴 إيقاف التايمر إجباري لتوفير المال والبطارية
        } else {
          // جلب موقع السائق فقط إذا تأكدنا أنه ليس null والرحلة بدأت
          if (driverCubit.isTripStarted && driverCubit.driverLocation != null) {
            updateLocation(driverCubit);
          }
        }
      });
    } else {
      // لو فتح الشاشة والرحلة منتهية بالفعل، ارسم المسار النهائي فقط
      driverCubit.getRoute();
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void updateLocation(DriverTripCubit driverCubit) {
    driverCubit.driverLocation = context.read<GlobalCubit>().userLocation;
    // 1. تحديث مكان أيقونة السيارة على الخريطة محلياً (مجانًا)
    driverCubit.setCarMarker(driverCubit.driverLocation!);

    // 2. تحريك الكاميرا للحاق بالسيارة لتبقى في منتصف الشاشة (مجانًا)
    driverCubit.mapController?.animateCamera(
      CameraUpdate.newLatLng(driverCubit.driverLocation!),
      duration: const Duration(milliseconds: 300),
    );

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalCubit, GlobalState>(
      listener: (context, state) {
        // if (state is UpdateUserLocationState) {
        //   final driverCubit = context.read<DriverTripCubit>();
        //   driverCubit.driverLocation = context.read<GlobalCubit>().userLocation;

        //   if (!driverCubit.tripEnded && driverCubit.driverLocation != null) {
        //     // 1. تحديث مكان أيقونة السيارة على الخريطة محلياً (مجانًا)
        //     driverCubit.setCarMarker(driverCubit.driverLocation!);

        //     // 2. تحريك الكاميرا للحاق بالسيارة لتبقى في منتصف الشاشة (مجانًا)
        //     driverCubit.mapController?.animateCamera(
        //       CameraUpdate.newLatLng(driverCubit.driverLocation!),
        //       duration: const Duration(milliseconds: 300),
        //     );

        //     // ❌ لا تضع getRoute() هنا أبداً!
        //   }
        // }

        // if (state is UpdateDriverLocationState) {
        //   context.read<DriverTripCubit>().driverLocation =
        //       context.read<GlobalCubit>().driverLocation;
        //   if (!context.read<DriverTripCubit>().tripEnded) {
        //     context.read<DriverTripCubit>().getRoute();
        //   }
        // }
        //----------------------------------------------------------------------
        // if (state is UpdateUserLocationState) {
        //   context.read<DriverTripCubit>().driverLocation =
        //       context.read<GlobalCubit>().userLocation;
        //   if (!context.read<DriverTripCubit>().tripEnded) {
        //     context.read<DriverTripCubit>().getRoute();
        //   }
        // }
        // if (state is UpdateUserLocationState) {
        //   final driverCubit = context.read<DriverTripCubit>();
        //   driverCubit.driverLocation = context.read<GlobalCubit>().userLocation;

        // // 1. تحديث مكان أيقونة السيارة على الخريطة محلياً
        // driverCubit.setCarMarker(driverCubit.driverLocation!);

        // // 2. تحريك الكاميرا للحاق بالسيارة
        // driverCubit.mapController?.animateCamera(
        //   CameraUpdate.newLatLng(driverCubit.driverLocation!),
        //   duration: const Duration(milliseconds: 300),
        // );

        // 3. حساب المسافة المتبقية في شريط التقدم (بدون إنترنت) باستخدام دالة Geolocator
        // قم بعمل دالة بداخل الـ Cubit تحسب المسافة بين موقع السائق الحالي وبين نقطة الوصول وتغير الـ RemainingDistanceNum

        // driverCubit.getRoute(); ❌ احذف هذا السطر الكارثي للابد من هذا المكان
        // if (!context.read<DriverTripCubit>().tripEnded) {
        //   context.read<DriverTripCubit>().getRoute();
        // }
        // }
      },
      builder: (context, state) {
        return BlocBuilder<DriverTripCubit, DriverTripState>(
          builder: (context, state) {
            final cubit = context.read<DriverTripCubit>();
            if (cubit.driverLocation == null) {
              return Container();
            }
            return Positioned.fill(
              child: GoogleMap(
                onMapCreated: (controller) {
                  cubit.mapController = controller;
                },
                style: context.read<GlobalCubit>().isDarkMode
                    ? context.read<GlobalCubit>().mapDarkStyle
                    : null,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: cubit.driverLocation!,
                  zoom: 14.151926040649414,
                ),
                markers: cubit.markers,
                polylines: cubit.polylines,
              ),
            );
          },
        );
      },
    );
  }
}
