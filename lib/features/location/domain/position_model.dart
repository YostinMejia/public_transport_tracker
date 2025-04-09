class PositionModel {
  double latitude;
  double longitude;

  PositionModel({required this.latitude, required this.longitude});

  void updateLocation(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }
}
