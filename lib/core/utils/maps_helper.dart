import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

import '../databases/api/dio_consumer.dart';
import '../imports/imports.dart';

class MapsHelper {
  static Future<int?> getArrivalTime({
    required double dropoffLat,
    required double dropoffLng,
    required int driverId,
  }) async {
    try {
      // 1. Fetch driver location from Realtime Firebase once
      final ref = FirebaseDatabase.instance.ref('driver_locations/$driverId');
      final snapshot = await ref.once();
      final data = snapshot.snapshot.value as Map?;

      if (data == null || data['latitude'] == null || data['longitude'] == null) {
        return null;
      }

      final driverLat = data['latitude'];
      final driverLng = data['longitude'];

      // 2. Fetch Directions from Google Maps API
      const String apiKey = "AIzaSyCuOWpUhowE4hXXmyFi0P_2wlCBQu6cFt4";
      final String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$driverLat,$driverLng&destination=$dropoffLat,$dropoffLng&key=$apiKey";

      final response = await sl<DioConsumer>().get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            response.data is Map ? Map<String, dynamic>.from(response.data as Map) : {};

        if (responseData['status'] == 'OK' && (responseData['routes'] as List).isNotEmpty) {
          final route = responseData['routes'][0];
          if (route['legs'] != null && (route['legs'] as List).isNotEmpty) {
            final leg = route['legs'][0];
            if (leg['duration'] != null && leg['duration']['value'] != null) {
              final seconds = leg['duration']['value'] as int;
              return (seconds / 60).round();
            }
          }
        }
      }
    } catch (e) {
      log('Error fetching arrival time: $e');
    }
    return null;
  }
}
