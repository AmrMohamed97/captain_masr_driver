import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../cubit/driver_share_trip_cubit.dart';

/* 
// فى هذه الصفحة يمكن وضع شرط 
// if (cubit.isTripStarted)
// لو هذا الشرط تحقق معناه ان الرحلة بدأ وبناء عليه اخلى رسم الخط على الخريطة متغير مع الحركة
*/
class DriverShareTripMap extends StatefulWidget {
  const DriverShareTripMap({super.key});

  @override
  State<DriverShareTripMap> createState() => _DriverShareTripMapState();
}

class _DriverShareTripMapState extends State<DriverShareTripMap> {
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    final driverCubit = context.read<DriverShareTripCubit>();

    if (!driverCubit.tripEnded) {
      // Initialize driverLocation from GlobalCubit
      driverCubit.driverLocation = context.read<GlobalCubit>().userLocation;
      
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

  void updateLocation(DriverShareTripCubit driverCubit) {
    driverCubit.driverLocation = context.read<GlobalCubit>().userLocation;
    // 1. تحديث مكان أيقونة السيارة على الخريطة محلياً (مجانًا)
    if (driverCubit.driverLocation != null) {
      driverCubit.setCarMarker(driverCubit.driverLocation!);

      // 2. تحريك الكاميرا للحاق بالسيارة لتبقى في منتصف الشاشة (مجانًا)
      driverCubit.mapController?.animateCamera(
        CameraUpdate.newLatLng(driverCubit.driverLocation!),
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalCubit, GlobalState>(
      listener: (context, state) {
        if (state is UpdateUserLocationState) {
          final driverCubit = context.read<DriverShareTripCubit>();
          driverCubit.driverLocation = context.read<GlobalCubit>().userLocation;

          if (!driverCubit.tripEnded && driverCubit.driverLocation != null) {
            // 1. تحديث مكان أيقونة السيارة على الخريطة محلياً (مجانًا)
            driverCubit.setCarMarker(driverCubit.driverLocation!);

            // 2. تحريك الكاميرا للحاق بالسيارة لتبقى في منتصف الشاشة (مجانًا)
            driverCubit.mapController?.animateCamera(
              CameraUpdate.newLatLng(driverCubit.driverLocation!),
              duration: const Duration(milliseconds: 300),
            );
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
          buildWhen: (previous, current) =>
              current is! DriverShareTimerState &&
              current is! DriverShareTravelTimeUpdatedState,
          builder: (context, state) {
            final cubit = context.read<DriverShareTripCubit>();
            if (cubit.driverLocation == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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
