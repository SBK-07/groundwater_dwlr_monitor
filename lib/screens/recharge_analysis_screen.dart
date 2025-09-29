import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mock_user.dart';
import '../services/ml_service.dart';

class RechargeAnalysisScreen extends StatefulWidget {
  final MockUser user;

  const RechargeAnalysisScreen({super.key, required this.user});

  @override
  State<RechargeAnalysisScreen> createState() => _RechargeAnalysisScreenState();
}

class _RechargeAnalysisScreenState extends State<RechargeAnalysisScreen> {
  final MLService _mlService = MLService.instance;
  
  bool _isLoading = false;
  Map<String, dynamic>? _rechargeAnalysis;
  String _selectedTimeframe = '12_months';
  
  final Map<String, String> _timeframeOptions = {
    '3_months': '3 Months',
    '6_months': '6 Months',
    '12_months': '12 Months',
    '24_months': '24 Months',
  };

  @override
  void initState() {
    super.initState();
    _loadRechargeAnalysis();
  }

  Future<void> _loadRechargeAnalysis() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _rechargeAnalysis = await _mlService.getRechargeAnalysis(
        location: widget.user.dwlrStationId,
        year: DateTime.now().year,
      );
    } catch (e) {
      print('Error loading recharge analysis: $e');
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
          'Recharge Analysis',
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
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _exportAnalysis,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rechargeAnalysis == null
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeframe Selector
                      _buildTimeframeSelector(),
                      const SizedBox(height: 20),
                      
                      // Recharge Summary
                      _buildRechargeSummary(),
                      const SizedBox(height: 20),
                      
                      // Monthly Recharge Chart
                      _buildMonthlyRechargeChart(),
                      const SizedBox(height: 20),
                      
                      // Efficiency Metrics
                      _buildEfficiencyMetrics(),
                      const SizedBox(height: 20),
                      
                      // Sources Analysis
                      _buildSourcesAnalysis(),
                      const SizedBox(height: 20),
                      
                      // Trends and Patterns
                      _buildTrendsAnalysis(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTimeframeSelector() {
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
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: _timeframeOptions.entries.map<Widget>((entry) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTimeframe = entry.key;
                        });
                        _loadRechargeAnalysis();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTimeframe == entry.key
                              ? Colors.blue[600]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedTimeframe == entry.key
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

  Widget _buildRechargeSummary() {
    final totalRecharge = _rechargeAnalysis!['total_recharge'] ?? 0.0;
    final averageRate = _rechargeAnalysis!['average_recharge_rate'] ?? 0.0;
    final efficiency = _rechargeAnalysis!['efficiency_score'] ?? 0.0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recharge Summary',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Total Recharge',
                    '${totalRecharge.toStringAsFixed(2)} mm',
                    Icons.water_drop,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Avg. Rate',
                    '${averageRate.toStringAsFixed(2)} mm/day',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Efficiency',
                    '${(efficiency * 100).toStringAsFixed(1)}%',
                    Icons.bar_chart,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
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

  Widget _buildMonthlyRechargeChart() {
    final monthlyData = _rechargeAnalysis!['monthly_recharge'] as List<dynamic>? ?? [];
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Recharge Patterns',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 10,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < monthlyData.length) {
                            final month = monthlyData[value.toInt()]['month'] ?? '';
                            return Text(
                              month.toString().substring(0, 3),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}mm',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
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
                  maxY: monthlyData.isEmpty ? 100 : monthlyData
                      .map<double>((item) => (item['recharge'] ?? 0.0).toDouble())
                      .reduce((a, b) => a > b ? a : b) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData.asMap().entries.map<FlSpot>((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          (entry.value['recharge'] ?? 0.0).toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue[600]!,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[400]!.withOpacity(0.3),
                            Colors.blue[400]!.withOpacity(0.1),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyMetrics() {
    final infiltrationRate = _rechargeAnalysis!['infiltration_rate'] ?? 0.0;
    final runoffLoss = _rechargeAnalysis!['runoff_loss'] ?? 0.0;
    final evaporationLoss = _rechargeAnalysis!['evaporation_loss'] ?? 0.0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Efficiency Metrics',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            
            _buildEfficiencyBar('Infiltration Rate', infiltrationRate, Colors.green),
            const SizedBox(height: 12),
            _buildEfficiencyBar('Runoff Loss', runoffLoss, Colors.orange),
            const SizedBox(height: 12),
            _buildEfficiencyBar('Evaporation Loss', evaporationLoss, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyBar(String label, double value, Color color) {
    final percentage = (value * 100).clamp(0, 100);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSourcesAnalysis() {
    final sources = _rechargeAnalysis!['recharge_sources'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recharge Sources',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            
            if (sources.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: sources.entries.map<PieChartSectionData>((entry) {
                      final value = (entry.value ?? 0.0).toDouble();
                      final color = _getSourceColor(entry.key);
                      
                      return PieChartSectionData(
                        color: color,
                        value: value,
                        title: '${value.toStringAsFixed(1)}%',
                        radius: 80,
                        titleStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              ...sources.entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getSourceColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key.replaceAll('_', ' ').toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${(entry.value ?? 0.0).toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getSourceColor(entry.key),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ] else ...[
              const Center(child: Text('No source data available')),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSourceColor(String source) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    
    return colors[source.hashCode % colors.length];
  }

  Widget _buildTrendsAnalysis() {
    final trends = _rechargeAnalysis!['trends'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trends & Insights',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            
            ...trends.entries.map<Widget>((entry) {
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
                        Icons.insights,
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
                              entry.value.toString(),
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
            
            if (trends.isEmpty) ...[
              const Center(child: Text('No trend data available')),
            ],
          ],
        ),
      ),
    );
  }

  void _exportAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Recharge analysis exported successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.blue,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Implement analysis viewing logic
          },
        ),
      ),
    );
  }
}