class PositionModel{
  double latitude;
  double longitude;

  PositionModel({required this.latitude, required this.longitude});

  void updateLocation(double latitude, double longitude){
    this.latitude = latitude;
    this.longitude = longitude;
  }

}