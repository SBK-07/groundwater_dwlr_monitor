class GroundwaterData {
  final DateTime date;
  final double waterLevel;
  final double rainfall;
  final double temperature;
  final double pHLevel;
  final double dissolvedOxygen;
  final String anomalyStatus;
  final String stationStatus;
  final String location;

  GroundwaterData({
    required this.date,
    required this.waterLevel,
    required this.rainfall,
    required this.temperature,
    required this.pHLevel,
    required this.dissolvedOxygen,
    required this.anomalyStatus,
    required this.stationStatus,
    required this.location,
  });
}