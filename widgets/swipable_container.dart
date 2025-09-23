import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:groundwater_monitor/models/groundwater_data.dart';
import 'package:groundwater_monitor/data/hardcoded_data.dart';

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
    final data = _getFilteredData();
    final pages = [
      // Current Area Visualization (Line Chart: Water Level and Rainfall)
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue[900]),
            ),
            Expanded(
              child: data.isEmpty
                  ? Center(child: Text('No data available'))
                  : LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < data.length) {
                            final date = data[value.toInt()].date;
                            return Text('${date.day}/${date.month}',
                                style: TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.waterLevel))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: data.asMap().entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.rainfall / 10))
                          .toList(),
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Groundwater Level Diagram (Bar Chart: pH and Dissolved Oxygen)
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue[900]),
            ),
            Expanded(
              child: data.isEmpty
                  ? Center(child: Text('No data available'))
                  : BarChart(
                BarChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            Text('Month ${value.toInt() + 1}', style: TextStyle(fontSize: 10)),
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  ),
                  barGroups: List.generate(12, (index) {
                    final monthData = data.where((d) => d.date.month == index + 1).toList();
                    final avgPh = monthData.isNotEmpty
                        ? monthData.fold(0.0, (sum, d) => sum + d.pHLevel) / monthData.length
                        : 0.0;
                    final avgDo = monthData.isNotEmpty
                        ? monthData.fold(0.0, (sum, d) => sum + d.dissolvedOxygen) / monthData.length
                        : 0.0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(toY: avgPh, color: Colors.blue, width: 8),
                        BarChartRodData(toY: avgDo, color: Colors.red, width: 8),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      // Date vs Level Graph (Scatter Chart: Temperature vs Water Level)
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Date vs Level Graph',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue[900]),
            ),
            Expanded(
              child: data.isEmpty
                  ? Center(child: Text('No data available'))
                  : ScatterChart(
                ScatterChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  ),
                  scatterSpots: data.map((d) => ScatterSpot(d.temperature, d.waterLevel)).toList(),
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
                  'Next Week Prediction: 45.2 m\n(Placeholder - Integrate ML model later)',
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