class DirectionsResponseModel {
  final String status;
  final List<RouteModel> routes;

  const DirectionsResponseModel({
    required this.status,
    required this.routes,
  });

  factory DirectionsResponseModel.fromJson(Map<String, dynamic> json) {
    return DirectionsResponseModel(
      status: json['status'] as String? ?? '',
      routes: (json['routes'] as List<dynamic>? ?? [])
          .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get isOk => status == 'OK';
  RouteModel? get firstRoute => routes.isNotEmpty ? routes.first : null;
}

class RouteModel {
  final String summary;
  final OverviewPolylineModel overviewPolyline;
  final List<LegModel> legs;

  const RouteModel({
    required this.summary,
    required this.overviewPolyline,
    required this.legs,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      summary: json['summary'] as String? ?? '',
      overviewPolyline: OverviewPolylineModel.fromJson(
        json['overview_polyline'] as Map<String, dynamic>? ?? {},
      ),
      legs: (json['legs'] as List<dynamic>? ?? [])
          .map((e) => LegModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  LegModel? get firstLeg => legs.isNotEmpty ? legs.first : null;
}

class OverviewPolylineModel {
  final String points;

  const OverviewPolylineModel({required this.points});

  factory OverviewPolylineModel.fromJson(Map<String, dynamic> json) {
    return OverviewPolylineModel(
      points: json['points'] as String? ?? '',
    );
  }
}

class LegModel {
  final String startAddress;
  final String endAddress;
  final DistanceDurationModel distance;
  final DistanceDurationModel duration;
  final List<StepModel> steps;

  const LegModel({
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.duration,
    required this.steps,
  });

  factory LegModel.fromJson(Map<String, dynamic> json) {
    return LegModel(
      startAddress: json['start_address'] as String? ?? '',
      endAddress: json['end_address'] as String? ?? '',
      distance: DistanceDurationModel.fromJson(
        json['distance'] as Map<String, dynamic>? ?? {},
      ),
      duration: DistanceDurationModel.fromJson(
        json['duration'] as Map<String, dynamic>? ?? {},
      ),
      steps: (json['steps'] as List<dynamic>? ?? [])
          .map((e) => StepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DistanceDurationModel {
  final String text;
  final int value;

  const DistanceDurationModel({required this.text, required this.value});

  factory DistanceDurationModel.fromJson(Map<String, dynamic> json) {
    return DistanceDurationModel(
      text: json['text'] as String? ?? '',
      value: json['value'] as int? ?? 0,
    );
  }
}

class StepModel {
  final String htmlInstructions;
  final String travelMode;
  final DistanceDurationModel distance;
  final DistanceDurationModel duration;
  final String? maneuver;
  final PolylineModel polyline;

  const StepModel({
    required this.htmlInstructions,
    required this.travelMode,
    required this.distance,
    required this.duration,
    this.maneuver,
    required this.polyline,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      htmlInstructions: json['html_instructions'] as String? ?? '',
      travelMode: json['travel_mode'] as String? ?? '',
      distance: DistanceDurationModel.fromJson(
        json['distance'] as Map<String, dynamic>? ?? {},
      ),
      duration: DistanceDurationModel.fromJson(
        json['duration'] as Map<String, dynamic>? ?? {},
      ),
      maneuver: json['maneuver'] as String?,
      polyline: PolylineModel.fromJson(
        json['polyline'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class PolylineModel {
  final String points;

  const PolylineModel({required this.points});

  factory PolylineModel.fromJson(Map<String, dynamic> json) {
    return PolylineModel(points: json['points'] as String? ?? '');
  }
}
