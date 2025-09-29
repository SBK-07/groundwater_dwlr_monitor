class MLPredictionResult {
  final double prediction;
  final double lowerBound;
  final double upperBound;
  final String scenario;
  final double confidence;
  final DateTime timestamp;
  final String? monthName;
  final Map<String, dynamic>? additionalData;

  MLPredictionResult({
    required this.prediction,
    required this.lowerBound,
    required this.upperBound,
    required this.scenario,
    required this.confidence,
    required this.timestamp,
    this.monthName,
    this.additionalData,
  });

  factory MLPredictionResult.fromJson(Map<String, dynamic> json) {
    return MLPredictionResult(
      prediction: json['prediction']?.toDouble() ?? 0.0,
      lowerBound: json['lower_bound']?.toDouble() ?? 0.0,
      upperBound: json['upper_bound']?.toDouble() ?? 0.0,
      scenario: json['scenario'] ?? 'normal',
      confidence: json['confidence']?.toDouble() ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      monthName: json['month_name'],
      additionalData: json['additional_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'lower_bound': lowerBound,
      'upper_bound': upperBound,
      'scenario': scenario,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'month_name': monthName,
      'additional_data': additionalData,
    };
  }

  String get formattedPrediction => '${prediction.toStringAsFixed(2)} m';
  String get formattedRange => '${lowerBound.toStringAsFixed(2)} - ${upperBound.toStringAsFixed(2)} m';
  String get formattedConfidence => '${(confidence * 100).toStringAsFixed(1)}%';
}