import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mock_user.dart';
import '../services/ml_service.dart';

class WaterLevelTrendsScreen extends StatefulWidget {
  final MockUser user;

  const WaterLevelTrendsScreen({super.key, required this.user});

  @override
  State<WaterLevelTrendsScreen> createState() => _WaterLevelTrendsScreenState();
}

class _WaterLevelTrendsScreenState extends State<WaterLevelTrendsScreen> {
  final MLService _mlService = MLService.instance;
  
  bool _isLoading = false;
  Map<String, dynamic>? _trendsData;
  String _selectedPeriod = 'yearly';
  
  final Map<String, String> _periodOptions = {
    'monthly': 'Monthly',
    'yearly': 'Yearly',
    'seasonal': 'Seasonal',
  };

  @override
  void initState() {
    super.initState();
    _loadTrendsData();
  }

  Future<void> _loadTrendsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate ML service call for trends data
      await Future.delayed(const Duration(milliseconds: 800));
      
      _trendsData = {
        'trend_direction': 'declining',
        'trend_magnitude': -0.15,
        'seasonal_pattern': {
          'monsoon': 'High recharge period',
          'summer': 'Depletion period',
          'winter': 'Stable period',
          'post_monsoon': 'Recovery period',
        },
        'yearly_change': -2.3,
        'monthly_averages': [
          {'month': 'Jan', 'level': 12.5, 'change': 0.2},
          {'month': 'Feb', 'level': 11.8, 'change': -0.7},
          {'month': 'Mar', 'level': 10.2, 'change': -1.6},
          {'month': 'Apr', 'level': 8.9, 'change': -1.3},
          {'month': 'May', 'level': 7.1, 'change': -1.8},
          {'month': 'Jun', 'level': 8.4, 'change': 1.3},
          {'month': 'Jul', 'level': 11.2, 'change': 2.8},
          {'month': 'Aug', 'level': 13.7, 'change': 2.5},
          {'month': 'Sep', 'level': 14.1, 'change': 0.4},
          {'month': 'Oct', 'level': 13.8, 'change': -0.3},
          {'month': 'Nov', 'level': 13.2, 'change': -0.6},
          {'month': 'Dec', 'level': 12.9, 'change': -0.3},
        ],
        'risk_assessment': 'moderate',
        'predictions': {
          'next_3_months': 'Continued decline expected',
          'next_6_months': 'Recovery likely with monsoon',
          'next_year': 'Overall stable with seasonal variations',
        },
      };
    } catch (e) {
      print('Error loading trends data: $e');
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
          'Water Level Trends',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[700]!, Colors.teal[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _exportTrends,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadTrendsData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trendsData == null
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period Selector
                      _buildPeriodSelector(),
                      const SizedBox(height: 20),
                      
                      // Trend Overview
                      _buildTrendOverview(),
                      const SizedBox(height: 20),
                      
                      // Monthly Trends Chart
                      _buildMonthlyTrendsChart(),
                      const SizedBox(height: 20),
                      
                      // Seasonal Analysis
                      _buildSeasonalAnalysis(),
                      const SizedBox(height: 20),
                      
                      // Risk Assessment
                      _buildRiskAssessment(),
                      const SizedBox(height: 20),
                      
                      // Future Predictions
                      _buildPredictions(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Period',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: _periodOptions.entries.map<Widget>((entry) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = entry.key;
                        });
                        _loadTrendsData();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == entry.key
                              ? Colors.teal[600]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedPeriod == entry.key
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendOverview() {
    final trendDirection = _trendsData!['trend_direction'] ?? 'stable';
    final trendMagnitude = _trendsData!['trend_magnitude'] ?? 0.0;
    final yearlyChange = _trendsData!['yearly_change'] ?? 0.0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trend Overview',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildTrendItem(
                    'Trend Direction',
                    trendDirection.toUpperCase(),
                    _getTrendIcon(trendDirection),
                    _getTrendColor(trendDirection),
                  ),
                ),
                Expanded(
                  child: _buildTrendItem(
                    'Magnitude',
                    '${trendMagnitude.toStringAsFixed(2)} m/yr',
                    Icons.speed,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildTrendItem(
                    'Yearly Change',
                    '${yearlyChange.toStringAsFixed(1)}%',
                    Icons.change_circle,
                    yearlyChange >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTrendColor(trendDirection).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getTrendColor(trendDirection).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    _getTrendIcon(trendDirection),
                    color: _getTrendColor(trendDirection),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getTrendDescription(trendDirection),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendsChart() {
    final monthlyData = _trendsData!['monthly_averages'] as List<dynamic>;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Water Level Trends',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 2,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < monthlyData.length) {
                            return Text(
                              monthlyData[value.toInt()]['month'],
                              style: GoogleFonts.poppins(fontSize: 12),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}m',
                            style: GoogleFonts.poppins(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  minX: 0,
                  maxX: (monthlyData.length - 1).toDouble(),
                  minY: 0,
                  maxY: 20,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData.asMap().entries.map<FlSpot>((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['level'].toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.teal[400]!, Colors.teal[600]!],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final change = monthlyData[index]['change'];
                          return FlDotCirclePainter(
                            radius: 5,
                            color: change >= 0 ? Colors.green : Colors.red,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal[400]!.withOpacity(0.3),
                            Colors.teal[400]!.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Water Level', Colors.teal[600]!, Icons.water),
                _buildLegendItem('Increase', Colors.green, Icons.arrow_upward),
                _buildLegendItem('Decrease', Colors.red, Icons.arrow_downward),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonalAnalysis() {
    final seasonalPattern = _trendsData!['seasonal_pattern'] as Map<String, dynamic>;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seasonal Patterns',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),
            
            ...seasonalPattern.entries.map<Widget>((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getSeasonColor(entry.key).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getSeasonColor(entry.key).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getSeasonColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getSeasonIcon(entry.key),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toUpperCase().replaceAll('_', ' '),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _getSeasonColor(entry.key),
                              ),
                            ),
                            Text(
                              entry.value,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskAssessment() {
    final riskLevel = _trendsData!['risk_assessment'] ?? 'unknown';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk Assessment',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getRiskColor(riskLevel).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getRiskColor(riskLevel)),
              ),
              child: Row(
                children: [
                  Icon(
                    _getRiskIcon(riskLevel),
                    color: _getRiskColor(riskLevel),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Risk Level: ${riskLevel.toUpperCase()}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _getRiskColor(riskLevel),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getRiskDescription(riskLevel),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictions() {
    final predictions = _trendsData!['predictions'] as Map<String, dynamic>;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ML Predictions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),
            
            ...predictions.entries.map<Widget>((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.replaceAll('_', ' ').toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                            Text(
                              entry.value,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'rising':
        return Icons.trending_up;
      case 'declining':
        return Icons.trending_down;
      case 'stable':
        return Icons.trending_flat;
      default:
        return Icons.help;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'rising':
        return Colors.green[600]!;
      case 'declining':
        return Colors.red[600]!;
      case 'stable':
        return Colors.blue[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getTrendDescription(String trend) {
    switch (trend.toLowerCase()) {
      case 'rising':
        return 'Water levels are showing an upward trend, indicating good recharge conditions.';
      case 'declining':
        return 'Water levels are declining over time. Monitor closely and consider conservation measures.';
      case 'stable':
        return 'Water levels remain relatively stable with minor seasonal variations.';
      default:
        return 'Trend analysis unavailable';
    }
  }

  Color _getSeasonColor(String season) {
    switch (season.toLowerCase()) {
      case 'monsoon':
        return Colors.blue[600]!;
      case 'summer':
        return Colors.orange[600]!;
      case 'winter':
        return Colors.cyan[600]!;
      case 'post_monsoon':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getSeasonIcon(String season) {
    switch (season.toLowerCase()) {
      case 'monsoon':
        return Icons.cloud;
      case 'summer':
        return Icons.wb_sunny;
      case 'winter':
        return Icons.ac_unit;
      case 'post_monsoon':
        return Icons.grass;
      default:
        return Icons.calendar_today;
    }
  }

  IconData _getRiskIcon(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return Icons.check_circle;
      case 'moderate':
        return Icons.warning;
      case 'high':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return Colors.green[600]!;
      case 'moderate':
        return Colors.orange[600]!;
      case 'high':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getRiskDescription(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return 'Current trends indicate sustainable groundwater levels with minimal risk.';
      case 'moderate':
        return 'Some concerns about long-term sustainability. Monitoring recommended.';
      case 'high':
        return 'Significant risk to groundwater sustainability. Immediate action required.';
      default:
        return 'Risk assessment unavailable';
    }
  }

  void _exportTrends() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Water level trends exported successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.teal,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Implement trends viewing logic
          },
        ),
      ),
    );
  }
}