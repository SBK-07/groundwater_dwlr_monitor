
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:groundwater_monitor/models/groundwater_data.dart';
import 'package:groundwater_monitor/data/hardcoded_data.dart';
import 'package:groundwater_monitor/models/mock_user.dart';
import 'package:groundwater_monitor/screens/home_screen.dart';
import 'package:groundwater_monitor/services/mock_auth_service.dart';
import 'package:groundwater_monitor/screens/dataset_page.dart';

class AuthorityDashboard extends StatefulWidget {
  final MockUser user;

  const AuthorityDashboard({super.key, required this.user});

  @override
  State<AuthorityDashboard> createState() => _AuthorityDashboardState();
}

class _AuthorityDashboardState extends State<AuthorityDashboard> {
  final MockAuthService _authService = MockAuthService();
  bool _isLoading = false;
  String _selectedYear = '2023';
  final List<String> _years = ['2022', '2023', '2024'];

  void _signOut() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _authService.signOut();
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Sign out error: $e');
    }
  }

// Filter data based on user's DWLR station and selected year
  List<GroundwaterData> _getFilteredData() {
    var data = getHardcodedData();
    String location = widget.user.dwlrStationId == 'Chengalpet' ? 'CGL' : widget.user.dwlrStationId;
    data = data.where((d) => d.location == location).toList();
    if (_selectedYear.isNotEmpty) {
      data = data.where((d) => d.date.year.toString() == _selectedYear).toList();
    }
    return data;
  }

// Generate chart data (last 7 days for the selected year)
  List<FlSpot> _getWaterLevelSpots() {
    final data = _getFilteredData();
    final recentData = data.where((d) => d.date.isAfter(DateTime(int.parse(_selectedYear), 1, 1))).take(7).toList();
    return recentData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.waterLevel)).toList();
  }

  List<FlSpot> _getRainfallSpots() {
    final data = _getFilteredData();
    final recentData = data.where((d) => d.date.isAfter(DateTime(int.parse(_selectedYear), 1, 1))).take(7).toList();
    return recentData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.rainfall / 10)).toList();
  }

// Calculate predictions (simple averages for demo)
  Map<String, String> _getPredictions() {
    final data = _getFilteredData();
    if (data.isEmpty) {
      return {
        'Next Week': 'N/A',
        'Next Month': 'N/A',
        'Next Year': 'N/A',
        'Rainfall Forecast': 'N/A',
      };
    }
    final avgWaterLevel = data.fold(0.0, (sum, d) => sum + d.waterLevel) / data.length;
    final avgRainfall = data.fold(0.0, (sum, d) => sum + d.rainfall) / data.length;
    return {
      'Next Week': '${(avgWaterLevel * 1.02).toStringAsFixed(1)} m',
      'Next Month': '${(avgWaterLevel * 0.98).toStringAsFixed(1)} m',
      'Next Year': '${(avgWaterLevel * 0.95).toStringAsFixed(1)} m',
      'Rainfall Forecast': '${(avgRainfall * 1.1).toStringAsFixed(1)} mm',
    };
  }

// Determine anomaly and station status
  String _getSystemStatus() {
    final data = _getFilteredData();
    return data.any((d) => d.anomalyStatus == 'Suspicious') ? 'Suspicious' : 'Normal';
  }

  String _getStationStatus() {
    final data = _getFilteredData();
    return data.isEmpty ? 'Unknown' : data.last.stationStatus;
  }

  @override
  Widget build(BuildContext context) {
    final predictions = _getPredictions();
    final systemStatus = _getSystemStatus();
    final stationStatus = _getStationStatus();

    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Dashboard', style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
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
              Card(
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
                        'Groundwater Monitoring Analytics',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

// Year Filter
              DropdownButtonFormField<String>(
                value: _selectedYear,
                decoration: InputDecoration(
                  labelText: 'Select Year',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
                  floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _years.map((year) {
                  return DropdownMenuItem(value: year, child: Text(year, style: GoogleFonts.poppins()));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

// Trend Analysis Section
              Text(
                'Trend Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Water Level & Rainfall Trends (Last 7 Days, $_selectedYear)',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _getFilteredData().isEmpty
                            ? Center(child: Text('No data available', style: GoogleFonts.poppins()))
                            : LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getWaterLevelSpots(),
                                isCurved: true,
                                color: Colors.blue,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                                dotData: const FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: _getRainfallSpots(),
                                isCurved: true,
                                color: Colors.green,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.green.withOpacity(0.3),
                                ),
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

// Predictions Section
              Text(
                'Water Level Predictions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildPredictionCard(
                    'Next Week',
                    predictions['Next Week']!,
                    Icons.next_week,
                    Colors.green[100]!,
                  ),
                  _buildPredictionCard(
                    'Next Month',
                    predictions['Next Month']!,
                    Icons.calendar_today,
                    Colors.orange[100]!,
                  ),
                  _buildPredictionCard(
                    'Next Year',
                    predictions['Next Year']!,
                    Icons.analytics,
                    Colors.purple[100]!,
                  ),
                  _buildPredictionCard(
                    'Rainfall Forecast',
                    predictions['Rainfall Forecast']!,
                    Icons.cloud,
                    Colors.blue[100]!,
                  ),
                ],
              ),
              const SizedBox(height: 20),

// Anomaly Detection Section
              Text(
                'Anomaly Detection',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: systemStatus == 'Normal' ? Colors.green[700] : Colors.orange[700],
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'System Status: $systemStatus',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: systemStatus == 'Normal' ? Colors.green[700] : Colors.orange[700],
                              ),
                            ),
                            Text(
                              systemStatus == 'Normal'
                                  ? 'No unusual readings detected in the last 24 hours'
                                  : 'Suspicious readings detected in the last 24 hours',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

// Station Health Section
              Text(
                'Station Health Monitoring',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.sensors, color: Colors.green[700], size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DWLR Station Status: $stationStatus',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'Last data transmission: ${DateTime.now().subtract(Duration(hours: 2)).toString().split('.')[0]}',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(
                          stationStatus == 'Active' ? 'HEALTHY' : 'MAINTENANCE',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: stationStatus == 'Active' ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

// Reports Section
              Text(
                'Reports & Insights',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
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
                          Icon(Icons.assessment, color: Colors.blue[700], size: 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Generate Monthly Report',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Report generated successfully!', style: GoogleFonts.poppins()),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: Text(
                            'Download PDF Report',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

// View Detailed Dataset Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DatasetPage(isAuthority: true)),
                    );
                  },
                  icon: const Icon(Icons.data_array),
                  label: Text(
                    'View Detailed Dataset',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard(String title, String value, IconData icon, Color color) {
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
}