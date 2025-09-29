import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mock_user.dart';
import '../models/ml_prediction_result.dart';
import '../services/ml_service.dart';

class PredictionScreen extends StatefulWidget {
  final MockUser user;

  const PredictionScreen({super.key, required this.user});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final MLService _mlService = MLService.instance;
  
  bool _isLoading = false;
  int _selectedMonths = 6;
  String _selectedScenario = 'normal';
  List<MLPredictionResult> _predictions = [];
  
  final Map<String, String> _scenarios = {
    'very_low': 'Very Low Rainfall',
    'low': 'Low Rainfall',
    'normal': 'Normal Rainfall',
    'high': 'High Rainfall',
    'very_high': 'Very High Rainfall',
  };

  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final predictionsMap = await _mlService.getFuturePredictions(
        location: widget.user.dwlrStationId,
        startYear: DateTime.now().year,
        yearsAhead: (_selectedMonths / 12).ceil(),
      );
      
      // Convert predictions to expected format
      _predictions = [];
      if (predictionsMap['predictions'] != null) {
        final predictions = predictionsMap['predictions'] as Map<int, Map<String, dynamic>>;
        for (final yearData in predictions.values) {
          if (yearData['monthlyData'] != null) {
            final monthlyData = yearData['monthlyData'] as List<dynamic>;
            for (final monthData in monthlyData.take(_selectedMonths)) {
              final waterLevel = monthData['waterLevel'] as double;
              final confidence = monthData['confidence'] as double;
              
              _predictions.add(MLPredictionResult(
                prediction: waterLevel,
                lowerBound: waterLevel * (1 - 0.1), // 10% lower bound
                upperBound: waterLevel * (1 + 0.1), // 10% upper bound
                scenario: _selectedScenario,
                confidence: confidence,
                timestamp: DateTime.now().add(Duration(days: 30 * (_predictions.length + 1))),
                monthName: monthData['monthName'] as String?,
                additionalData: {
                  'month': monthData['month'],
                  'rainfall': monthData['rainfall'],
                  'temperature': monthData['temperature'],
                },
              ));
            }
          }
        }
      }
    } catch (e) {
      print('Error loading predictions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Future Predictions',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadPredictions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Controls Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prediction Parameters',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Months Selector
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Months Ahead: $_selectedMonths',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Slider(
                                      value: _selectedMonths.toDouble(),
                                      min: 1,
                                      max: 12,
                                      divisions: 11,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMonths = value.toInt();
                                        });
                                      },
                                      onChangeEnd: (value) => _loadPredictions(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          // Scenario Selector
                          const SizedBox(height: 16),
                          Text(
                            'Rainfall Scenario',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedScenario,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _scenarios.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedScenario = value;
                                });
                                _loadPredictions();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Chart Card
                  if (_predictions.isNotEmpty) _buildChartCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Predictions List
                  if (_predictions.isNotEmpty) _buildPredictionsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Water Level Forecast Chart',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 0.5,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _predictions.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'M${value.toInt() + 1}',
                                style: GoogleFonts.poppins(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(1)}m',
                            style: GoogleFonts.poppins(fontSize: 10),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  lineBarsData: [
                    // Main prediction line
                    LineChartBarData(
                      spots: _predictions.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.prediction);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue[600]!,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue[600]!.withOpacity(0.1),
                      ),
                    ),
                    // Upper bound line
                    LineChartBarData(
                      spots: _predictions.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.upperBound);
                      }).toList(),
                      isCurved: true,
                      color: Colors.green[400]!,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                    // Lower bound line
                    LineChartBarData(
                      spots: _predictions.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.lowerBound);
                      }).toList(),
                      isCurved: true,
                      color: Colors.red[400]!,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Prediction', Colors.blue[600]!),
                _buildLegendItem('Upper Bound', Colors.green[400]!),
                _buildLegendItem('Lower Bound', Colors.red[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPredictionsList() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Predictions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _predictions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(
                    prediction.monthName ?? 'Month ${index + 1}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Predicted Level: ${prediction.formattedPrediction}',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      Text(
                        'Range: ${prediction.formattedRange}',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      prediction.formattedConfidence,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}