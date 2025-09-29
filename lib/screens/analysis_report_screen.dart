import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mock_user.dart';
import '../services/ml_service.dart';

class AnalysisReportScreen extends StatefulWidget {
  final MockUser user;

  const AnalysisReportScreen({super.key, required this.user});

  @override
  State<AnalysisReportScreen> createState() => _AnalysisReportScreenState();
}

class _AnalysisReportScreenState extends State<AnalysisReportScreen> {
  final MLService _mlService = MLService.instance;
  
  bool _isLoading = false;
  Map<String, dynamic>? _analysisReport;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAnalysisReport();
  }

  Future<void> _loadAnalysisReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _analysisReport = await _mlService.generateAnalysisReport(
        location: widget.user.dwlrStationId,
        year: _startDate.year,
      );
    } catch (e) {
      print('Error loading analysis report: $e');
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
          'Analysis Report',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _exportReport,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAnalysisReport,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analysisReport == null
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Range Selector
                      _buildDateRangeCard(),
                      const SizedBox(height: 20),
                      
                      // Overview Card
                      _buildOverviewCard(),
                      const SizedBox(height: 20),
                      
                      // Sustainability Score Card
                      _buildSustainabilityCard(),
                      const SizedBox(height: 20),
                      
                      // Recommendations Card
                      _buildRecommendationsCard(),
                      const SizedBox(height: 20),
                      
                      // Risk Assessment Card
                      _buildRiskAssessmentCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDateRangeCard() {
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
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                        _loadAnalysisReport();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                        _loadAnalysisReport();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Overview',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    'Average Water Level',
                    '${_analysisReport!['average_water_level']?.toStringAsFixed(2) ?? 'N/A'} m',
                    Icons.water_drop,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    'Trend Direction',
                    _analysisReport!['trend'] ?? 'Unknown',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Location: ${widget.user.dwlrStationId}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
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
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityCard() {
    final sustainabilityScore = _analysisReport!['sustainability_score'] ?? 0.0;
    final scorePercentage = (sustainabilityScore * 100).toInt();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sustainability Assessment',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sustainability Score',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$scorePercentage%',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: _getSustainabilityColor(scorePercentage),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSustainabilityLabel(scorePercentage),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _getSustainabilityColor(scorePercentage),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 120,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: _getSustainabilityColor(scorePercentage),
                            value: scorePercentage.toDouble(),
                            title: '$scorePercentage%',
                            radius: 40,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.grey[300]!,
                            value: (100 - scorePercentage).toDouble(),
                            title: '',
                            radius: 40,
                          ),
                        ],
                        startDegreeOffset: -90,
                        sectionsSpace: 2,
                        centerSpaceRadius: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSustainabilityColor(int score) {
    if (score >= 80) return Colors.green[600]!;
    if (score >= 60) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  String _getSustainabilityLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
  }

  Widget _buildRecommendationsCard() {
    final recommendations = _analysisReport!['recommendations'] as List<dynamic>? ?? [];
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ML-Generated Recommendations',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            
            ...recommendations.map<Widget>((recommendation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        recommendation.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskAssessmentCard() {
    final riskLevel = _analysisReport!['risk_level'] ?? 'unknown';
    final seasonalPatterns = _analysisReport!['seasonal_patterns'] as Map<String, dynamic>? ?? {};
    
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
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
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
                          fontWeight: FontWeight.w600,
                          color: _getRiskColor(riskLevel),
                        ),
                      ),
                      Text(
                        _getRiskDescription(riskLevel),
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
            
            const SizedBox(height: 16),
            
            if (seasonalPatterns.isNotEmpty) ...[
              Text(
                'Seasonal Patterns',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...seasonalPatterns.entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          '${entry.key.replaceAll('_', ' ').toUpperCase()}:',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value.toString(),
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
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

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
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

  String _getRiskDescription(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return 'Groundwater levels are stable and sustainable';
      case 'moderate':
        return 'Some concerns about groundwater sustainability';
      case 'high':
        return 'Immediate action needed to ensure sustainability';
      default:
        return 'Risk level assessment unavailable';
    }
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Analysis report exported successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Implement report viewing logic
          },
        ),
      ),
    );
  }
}