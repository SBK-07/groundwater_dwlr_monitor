import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:groundwater_monitor/models/groundwater_data.dart';
import 'package:groundwater_monitor/data/hardcoded_data.dart';
import 'package:groundwater_monitor/widgets/water_level_animation.dart';

class SwipableContainer extends StatelessWidget {
  final PageController controller;
  final double currentIndex;
  final String selectedLocation;

  const SwipableContainer({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.selectedLocation,
  });

  List<GroundwaterData> _getFilteredData() {
    return getHardcodedData()
        .where((d) => d.location == selectedLocation)
        .toList()
        .take(100)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<GroundwaterData> _getFilteredData() {
      final location = selectedLocation == 'Chengalpet' ? 'CGL' : selectedLocation;
      return getHardcodedData()
          .where((d) => d.location == location)
          .toList()
          .take(5) // only 5 for clarity
          .toList();
    }
    final filteredData = _getFilteredData();
    final hardcodedLabels = ['19/09', '20/09', '21/09', '22/09', '23/09', '24/09'];

    final data = _getFilteredData();
    final pages = [
      // Current Area Visualization (Line Chart: Water Level and Rainfall)
      // Current Area Visualization (Water Level Animation)
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Current Area Visualization',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blue[900],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Background zoomed and full
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightBlueAccent, Colors.brown],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                         // stops: [0.0, 0.90],
                        ),
                      ),
                    ),
                  ),
                  // Water container aligned inside background (right side)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: WaterLevelAnimation(
                        waterLevel: 4.12, // Replace with dynamic data later
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Groundwater Level Diagram (Bar Chart: Water Level and Rainfall)
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Groundwater Level Diagram',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[900]
              ),
            ),
            Expanded(
              child: filteredData.isEmpty
                  ? Center(child: Text('No data available'))
                  : BarChart(
                BarChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < hardcodedLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                hardcodedLabels[index],
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  barGroups: List.generate(filteredData.length, (index) {
                    final d = filteredData[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                            toY: d.waterLevel,
                            color: Colors.blue,
                            width: 12
                        ),
                        BarChartRodData(
                            toY: d.rainfall,
                            color: Colors.green,
                            width: 12
                        ),
                      ],
                      barsSpace: 4,
                    );
                  }),
                  barTouchData: BarTouchData(enabled: true),
                  alignment: BarChartAlignment.spaceAround,
                ),
              ),
            ),
          ],
        ),
      ),


      // Date vs Level Graph (Scatter Chart: Temperature vs Water Level)
      // Third slot: Water Level Trend with Forecast
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Water Level Trend & Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue[900]),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          // Hardcoded dates 19/09 to 24/09
                          const dates = ['20/09', '21/09', '22/09', '23/09', '24/09', '25/09'];
                          if (value.toInt() >= 0 && value.toInt() < dates.length) {
                            return Text(dates[value.toInt()], style: TextStyle(fontSize: 10));
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  lineBarsData: [
                    // Actual Water Level
                    LineChartBarData(
                      spots: List.generate(filteredData.length, (index) {
                        return FlSpot(index.toDouble(), filteredData[index].waterLevel);
                      }),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                    // Forecast (dotted line)
                    if (filteredData.length >= 1)
                      LineChartBarData(
                        spots: [
                          FlSpot(filteredData.length - 1.toDouble(),
                              filteredData.last.waterLevel), // start from last actual
                          FlSpot(filteredData.length.toDouble(),
                              filteredData.last.waterLevel + 0.2), // simple forecast
                          FlSpot(filteredData.length + 1.toDouble(),
                              filteredData.last.waterLevel + 0.4),
                        ],
                        isCurved: true,
                        color: Colors.blueAccent,
                        barWidth: 2,
                        dashArray: [5, 5], // dotted line
                        dotData: FlDotData(show: false),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Predictions/Other Info (Placeholder with Dummy Prediction)
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Predictions/Other Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue[900]),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Next Week Prediction: 45.2 m ',
                  style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Map the infinite index to the actual page index (0 to pages.length - 1)
                final pageIndex = index % pages.length;
                return pages[pageIndex];
              },
              itemCount: 10000, // Large number to simulate infinite scrolling
            ),
            Positioned(
              top: 184,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 36, color: Colors.black),
                onPressed: () {
                  if (controller.hasClients) {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 184,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_right, size: 36, color: Colors.black),
                onPressed: () {
                  if (controller.hasClients) {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: (currentIndex % pages.length).round() == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: (currentIndex % pages.length).round() == index
                            ? Colors.blue[700]
                            : Colors.grey[400],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}