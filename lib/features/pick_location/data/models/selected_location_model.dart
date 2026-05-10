class SelectedLocationModel {
  String? address;
  double? lat, lon;

  SelectedLocationModel({
    required this.address,
    required this.lat,
    required this.lon,
  });

  factory SelectedLocationModel.fromJson(Map json) {
    return SelectedLocationModel(
      address: json["address"],
      lat: json["lat"],
      lon: json["lon"],
    );
  }

  Map toJson() => {
        "address": address,
        "lat": lat,
        "lon": lon,
      };
}
