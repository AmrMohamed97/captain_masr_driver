class PreferencesModel {
  final bool coolRide, quietRide, smokingFriendly, petsFree;

  PreferencesModel({
    required this.coolRide,
    required this.quietRide,
    required this.smokingFriendly,
    required this.petsFree,
  });

  factory PreferencesModel.fromJson(Map json) {
    return PreferencesModel(
      coolRide: json["cool_ride"],
      quietRide: json["quiet_ride"],
      smokingFriendly: json["smoking_friendly"],
      petsFree: json["pets_free"],
    );
  }

  Map toJson() => {
        "cool_ride": coolRide,
        "quiet_ride": quietRide,
        "smoking_friendly": smokingFriendly,
        "pets_free": petsFree,
      };
}
