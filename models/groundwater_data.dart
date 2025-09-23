import 'package:flutter/material.dart';
import 'package:groundwater_monitor/l10n/app_localizations.dart';

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

  // Helper method to get localized status
  String getLocalizedAnomalyStatus(BuildContext context) {
    final l = AppLocalizations.of(context)!; // ✅ non-null
    return anomalyStatus == 'Suspicious' ? l.suspicious : l.normal;
  }

  String getLocalizedStationStatus(BuildContext context) {
    final l = AppLocalizations.of(context)!; // ✅ non-null
    return stationStatus == 'Active' ? l.active : stationStatus;
  }
}
