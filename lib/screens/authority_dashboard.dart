import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:groundwater_monitor/models/groundwater_data.dart';
import 'package:groundwater_monitor/data/hardcoded_data.dart';
import 'package:groundwater_monitor/models/mock_user.dart';
import 'package:groundwater_monitor/screens/home_screen.dart';
import 'package:groundwater_monitor/services/mock_auth_service.dart';
import 'package:groundwater_monitor/services/ml_service.dart';
import 'package:groundwater_monitor/screens/dataset_page.dart';
import 'package:groundwater_monitor/screens/prediction_screen.dart';
import 'package:groundwater_monitor/screens/analysis_report_screen.dart';
import 'package:groundwater_monitor/screens/recharge_analysis_screen.dart';
import 'package:groundwater_monitor/screens/water_level_trends_screen.dart';
import 'package:groundwater_monitor/screens/chatbot_screen.dart';

class AuthorityDashboard extends StatefulWidget {
  final MockUser user;

  const AuthorityDashboard({super.key, required this.user});

  @override
  State<AuthorityDashboard> createState() => _AuthorityDashboardState();
}

class _AuthorityDashboardState extends State<AuthorityDashboard> {
  final MockAuthService _authService = MockAuthService();
  final MLService _mlService = MLService.instance;
  
  bool _isLoading = false;
  String _selectedYear = '2024';
  final List<String> _years = ['2020', '2021', '2022', '2023', '2024', '2025'];
  
  Map<String, dynamic>? _mlData;
  List<Map<String, dynamic>>? _waterLevelPredictions;
  bool _isMLDataLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMLData();
  }

  Future<void> _loadMLData() async {
    setState(() {
      _isMLDataLoading = true;
    });

    try {
      final year = int.parse(_selectedYear);
      final location = widget.user.dwlrStationId;
      
      // Load ML-generated data for the selected year
      final mlData = await _mlService.getYearlyData(
        location: location,
        year: year,
      );
      
      final predictions = await _mlService.getWaterLevelPredictions(
        location: location,
        year: year,
        months: 12,
      );

      setState(() {
        _mlData = mlData;
        _waterLevelPredictions = predictions;
        _isMLDataLoading = false;
      });
    } catch (e) {
      print('Error loading ML data: $e');
      setState(() {
        _isMLDataLoading = false;
      });
    }
  }

  void _onYearChanged(String? newYear) {
    if (newYear != null && newYear != _selectedYear) {
      setState(() {
        _selectedYear = newYear;
      });
      _loadMLData(); // Reload ML data for new year
    }
  }

  void _signOut() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _authService.signOut();
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Sign out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Authority Dashboard',
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
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatbotScreen(user: widget.user),
                ),
              );
            },
            tooltip: 'ML Assistant',
          ),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.logout, color: Colors.white),
            onPressed: _isLoading ? null : _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeCard(),
              const SizedBox(height: 20),

              // Year Filter with ML Integration
              _buildYearSelector(),
              const SizedBox(height: 20),

              // ML Features Section
              _buildMLFeaturesCard(),
              const SizedBox(height: 20),

              // Trend Analysis Section
              _buildTrendAnalysisCard(),
              const SizedBox(height: 20),

              // Quick Stats
              _buildQuickStatsGrid(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotScreen(user: widget.user),
            ),
          );
        },
        backgroundColor: Colors.purple[600],
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        tooltip: 'ML Assistant - Ask me anything!',
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: Text(
                    widget.user.name.isNotEmpty
                        ? widget.user.name[0].toUpperCase()
                        : 'A',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${widget.user.name}!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[900],
                        ),
                      ),
                      Text(
                        'DWLR Station: ${widget.user.dwlrStationId}',
                        style: GoogleFonts.poppins(
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'ML-Powered Groundwater Monitoring Analytics',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Analysis Year',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900],
                  ),
                ),
                const Spacer(),
                if (_isMLDataLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue[700],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<String>(
              value: _selectedYear,
              decoration: InputDecoration(
                labelText: 'Select Year for ML Analysis',
                prefixIcon: Icon(Icons.psychology, color: Colors.blue[700]),
                floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.blue[50],
              ),
              items: _years.map((year) {
                final yearInt = int.parse(year);
                final isTraining = yearInt <= 2019;
                final isPrediction = yearInt > 2019;
                
                return DropdownMenuItem(
                  value: year,
                  child: Row(
                    children: [
                      Text(year, style: GoogleFonts.poppins()),
                      const SizedBox(width: 8),
                      if (isTraining)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Training',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (isPrediction)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ML Prediction',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: _onYearChanged,
            ),
            
            if (_mlData != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _mlData!['isMLPrediction'] ? Colors.orange[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _mlData!['isMLPrediction'] ? Colors.orange[200]! : Colors.green[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _mlData!['isMLPrediction'] ? Icons.psychology : Icons.history,
                      color: _mlData!['isMLPrediction'] ? Colors.orange[700] : Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _mlData!['isMLPrediction']
                            ? 'ML Prediction based on 2012-2019 training data'
                            : 'Historical data from training period',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _mlData!['isMLPrediction'] ? Colors.orange[800] : Colors.green[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrendAnalysisCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _mlData?['isMLPrediction'] == true ? Icons.psychology : Icons.analytics,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _mlData?['isMLPrediction'] == true
                      ? 'ML Predicted Water Level ($_selectedYear)'
                      : 'Historical Water Level ($_selectedYear)',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _isMLDataLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.blue[700]))
                  : _mlData == null
                      ? Center(
                          child: Text(
                            'No ML data available',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 0.5,
                              verticalInterval: 2,
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
                                  interval: 2,
                                  getTitlesWidget: (value, meta) {
                                    final monthIndex = value.toInt();
                                    if (monthIndex >= 0 && monthIndex < (_mlData!['monthlyData'] as List).length) {
                                      final monthData = (_mlData!['monthlyData'] as List)[monthIndex];
                                      return Text(
                                        monthData['monthName'].toString().substring(0, 3),
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
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
                                  interval: 0.5,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toStringAsFixed(1)}m',
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
                            maxX: ((_mlData!['monthlyData'] as List).length - 1).toDouble(),
                            minY: 0,
                            maxY: _getMaxWaterLevel() * 1.2,
                            lineBarsData: [
                              // Water Level Line
                              LineChartBarData(
                                spots: _getWaterLevelSpots(),
                                isCurved: true,
                                color: _mlData!['isMLPrediction'] ? Colors.orange[600] : Colors.blue[600],
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: _mlData!['isMLPrediction'] ? Colors.orange[600]! : Colors.blue[600]!,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: (_mlData!['isMLPrediction'] ? Colors.orange[600]! : Colors.blue[600]!)
                                      .withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
            
            if (_mlData != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Avg. Water Level: ${(_mlData!['summary']['avgWaterLevel'] as double).toStringAsFixed(2)}m | '
                        'Trend: ${_mlData!['summary']['trend']}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMLFeaturesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[400]!, Colors.purple[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ML-Powered Analytics',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ELM + XGBoost Ensemble Model',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '94.2% Accuracy',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PredictionScreen(user: widget.user),
                          ),
                        );
                      },
                      icon: const Icon(Icons.trending_up, size: 16),
                      label: Text('Predictions', style: GoogleFonts.poppins(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalysisReportScreen(user: widget.user),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics, size: 16),
                      label: Text('Analysis', style: GoogleFonts.poppins(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(
          'Current Level',
          _mlData != null ? '${(_mlData!['summary']['avgWaterLevel'] as double).toStringAsFixed(2)}m' : 'Loading...',
          Icons.water_drop,
          Colors.blue[100]!,
        ),
        _buildStatCard(
          'Status',
          _mlData?['isMLPrediction'] == true ? 'Predicted' : 'Historical',
          Icons.info,
          Colors.green[100]!,
        ),
        _buildStatCard(
          'Year',
          _selectedYear,
          Icons.calendar_today,
          Colors.orange[100]!,
        ),
        _buildStatCard(
          'Station',
          widget.user.dwlrStationId,
          Icons.location_on,
          Colors.purple[100]!,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.blue[900],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for ML data visualization
  List<FlSpot> _getWaterLevelSpots() {
    if (_mlData == null || _mlData!['monthlyData'] == null) return [];
    
    final monthlyData = _mlData!['monthlyData'] as List<dynamic>;
    return monthlyData.asMap().entries.map<FlSpot>((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value['waterLevel'] as double),
      );
    }).toList();
  }

  double _getMaxWaterLevel() {
    if (_mlData == null || _mlData!['monthlyData'] == null) return 5.0;
    
    final monthlyData = _mlData!['monthlyData'] as List<dynamic>;
    double maxLevel = 0.0;
    
    for (final data in monthlyData) {
      final level = data['waterLevel'] as double;
      if (level > maxLevel) maxLevel = level;
    }
    
    return maxLevel > 0 ? maxLevel : 5.0;
  }
}