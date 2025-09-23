import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groundwater_monitor/data/hardcoded_data.dart';
import 'package:groundwater_monitor/models/groundwater_data.dart';
import 'package:intl/intl.dart';

class DatasetPage extends StatefulWidget {
  final bool isAuthority;

  const DatasetPage({super.key, this.isAuthority = false});

  @override
  State<DatasetPage> createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  String? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _filtersApplied = false;
  List<GroundwaterData> _dataset = [];

  final List<String> _locations = ['Chennai', 'Chengalpet', 'Madurai', 'Nilgiris', 'Cuddalore'];

  List<GroundwaterData> _filterData() {
    var data = getHardcodedData();
    if (_selectedLocation != null) {
      // Map 'Chengalpet' to 'CGL' for data compatibility
      String location = _selectedLocation == 'Chengalpet' ? 'CGL' : _selectedLocation!;
      data = data.where((d) => d.location == location).toList();
    }
    if (_startDate != null && _endDate != null) {
      data = data.where((d) => d.date.isAfter(_startDate!.subtract(Duration(days: 1))) && d.date.isBefore(_endDate!.add(Duration(days: 1)))).toList();
    }
    return data;
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyFilters() {
    if (_selectedLocation == null || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select location, start date, and end date', style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('End date must be after start date', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _filtersApplied = false;
    });

    // Simulate data fetch delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _dataset = _filterData();
        _isLoading = false;
        _filtersApplied = true;
      });
    });
  }

  void _downloadDataset() {
    if (_dataset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No data available to download. Apply filters first.', style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate download process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Download Successful', style: GoogleFonts.poppins()),
          content: Text(
            'Dataset for $_selectedLocation (${_startDate!.toString().split(' ')[0]} to ${_endDate!.toString().split(' ')[0]}) has been downloaded as CSV.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedLocation = null;
      _startDate = null;
      _endDate = null;
      _dataset.clear();
      _filtersApplied = false;
    });
  }

  Color _getWaterLevelColor(double level) {
    if (level < 2) return Colors.red; // Adjusted for realistic CSV data
    if (level < 5) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Suspicious':
        return Colors.orange;
      case 'Critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAuthority ? 'Authority Dataset' : 'Groundwater Dataset',
          style: GoogleFonts.poppins(),
        ),
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
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Filters Section
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Filter Dataset',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Location Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Select Location',
                        prefixIcon: Icon(Icons.location_on, color: Colors.blue[700]),
                        floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Date Range Picker
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
                              floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                              hintText: _startDate == null
                                  ? 'Select start date'
                                  : DateFormat('yyyy-MM-dd').format(_startDate!),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onTap: _selectStartDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
                              floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                              hintText: _endDate == null
                                  ? 'Select end date'
                                  : DateFormat('yyyy-MM-dd').format(_endDate!),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onTap: _selectEndDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _applyFilters,
                            icon: const Icon(Icons.filter_alt),
                            label: Text(
                              'Apply Filters',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.clear),
                          label: Text('Clear', style: GoogleFonts.poppins()),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.blue[700]!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Dataset Display Section
            Expanded(
              child: _isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading dataset...',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : _dataset.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.data_array,
                      size: 64,
                      color: Colors.blue[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _filtersApplied
                          ? 'No data available for selected filters'
                          : 'Apply filters to view dataset',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Dataset Summary
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${_dataset.length} records',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                            Chip(
                              label: Text(
                                _selectedLocation!,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.blue[700],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Dataset Table
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Date',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Water Level',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Rainfall',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    if (widget.isAuthority) ...[
                                      Expanded(
                                        child: Text(
                                          'Temperature',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'pH Level',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Dissolved Oxygen',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Anomaly Status',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Station Status',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ] else ...[
                                      Expanded(
                                        child: Text(
                                          'pH Level',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Table Body
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _dataset.length,
                                  itemBuilder: (context, index) {
                                    final data = _dataset[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: index.isEven ? Colors.white : Colors.grey[50],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '${data.date.day}/${data.date.month}/${data.date.year}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data.waterLevel.toStringAsFixed(1)} m',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: _getWaterLevelColor(data.waterLevel),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data.rainfall.toStringAsFixed(1)} mm',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.blue[600],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          if (widget.isAuthority) ...[
                                            Expanded(
                                              child: Text(
                                                '${data.temperature.toStringAsFixed(1)} °C',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.blue[600],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${data.pHLevel.toStringAsFixed(1)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.blue[600],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${data.dissolvedOxygen.toStringAsFixed(1)} mg/L',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.blue[600],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(data.anomalyStatus),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  data.anomalyStatus,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                data.stationStatus,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.blue[600],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ] else ...[
                                            Expanded(
                                              child: Text(
                                                '${data.pHLevel.toStringAsFixed(1)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.blue[600],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Download Button Section
            if (_dataset.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _downloadDataset,
                    icon: _isLoading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.download),
                    label: _isLoading
                        ? Text('Downloading...', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))
                        : Text(
                      'Download CSV Dataset',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}