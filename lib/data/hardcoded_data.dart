import 'package:groundwater_monitor/models/groundwater_data.dart';

List<GroundwaterData> getHardcodedData() {
  final List<GroundwaterData> data = [
    // CGL 2023 (first 10 days, cleaned)
    GroundwaterData(
      date: DateTime(2023, 1, 1),
      waterLevel: 1.698,
      rainfall: 55.280,
      temperature: 4.556,
      pHLevel: 8.776,
      dissolvedOxygen: 11.449,
      anomalyStatus: 1.698 > 5 ? 'Suspicious' : 'Normal',
      stationStatus: 'Active',
      location: 'CGL',
    ),
    // ... (add more CGL 2023, 2022, 2024, Chennai 2022–2024)
    GroundwaterData(
      date: DateTime(2023, 1, 1),
      waterLevel: 1.787,
      rainfall: 40.213,
      temperature: 1.945,
      pHLevel: 7.008,
      dissolvedOxygen: 7.543,
      anomalyStatus: 1.787 > 5 ? 'Suspicious' : 'Normal',
      stationStatus: 'Active',
      location: 'Chennai',
    ),
    // ... (add more)
  ];
  return data.where((d) {
    return d.waterLevel >= 0 &&
        d.waterLevel <= 10 &&
        d.rainfall <= 1000 &&
        d.temperature <= 50 &&
        d.pHLevel >= 0 &&
        d.pHLevel <= 14 &&
        d.dissolvedOxygen >= 0 &&
        d.dissolvedOxygen <= 15;
  }).toList();
}