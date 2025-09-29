// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Groundwater Monitor';

  @override
  String get authorityDashboard => 'Authority Dashboard';

  @override
  String get authoritySignIn => 'Authority Sign In';

  @override
  String get authorityRegistration => 'Authority Registration';

  @override
  String get welcome => 'Welcome';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get dwlrStationId => 'DWLR Station ID';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get demoCredentials =>
      'Demo Credentials:\nadmin@waterauthority.com / any password';

  @override
  String get invalidCredentials => 'Invalid credentials. Please try again.';

  @override
  String get accountCreated => 'Account created successfully!';

  @override
  String get emailExists =>
      'Email already exists. Please use a different email.';

  @override
  String get resetEmailSent => 'Password reset email sent! Check your inbox.';

  @override
  String get enterEmailFirst => 'Please enter your email address first.';

  @override
  String get groundwaterMonitoring => 'Groundwater Monitoring Analytics';

  @override
  String get selectYear => 'Select Year';

  @override
  String get trendAnalysis => 'Trend Analysis';

  @override
  String waterLevelRainfallTrends(Object year) {
    return 'Water Level & Rainfall Trends (Last 7 Days, $year)';
  }

  @override
  String get waterLevelPredictions => 'Water Level Predictions';

  @override
  String get nextWeek => 'Next Week';

  @override
  String get nextMonth => 'Next Month';

  @override
  String get nextYear => 'Next Year';

  @override
  String get rainfallForecast => 'Rainfall Forecast';

  @override
  String get anomalyDetection => 'Anomaly Detection';

  @override
  String get systemStatus => 'System Status';

  @override
  String get noUnusualReadings =>
      'No unusual readings detected in the last 24 hours';

  @override
  String get suspiciousReadings =>
      'Suspicious readings detected in the last 24 hours';

  @override
  String get stationHealthMonitoring => 'Station Health Monitoring';

  @override
  String get dwlrStationStatus => 'DWLR Station Status';

  @override
  String get lastTransmission => 'Last data transmission';

  @override
  String get reportsInsights => 'Reports & Insights';

  @override
  String get generateMonthlyReport => 'Generate Monthly Report';

  @override
  String get downloadPdfReport => 'Download PDF Report';

  @override
  String get viewDetailedDataset => 'View Detailed Dataset';

  @override
  String get filterDataset => 'Filter Dataset';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get clear => 'Clear';

  @override
  String showingRecords(Object count) {
    return 'Showing $count records';
  }

  @override
  String get downloadCsv => 'Download CSV Dataset';

  @override
  String get downloadSuccessful => 'Download Successful';

  @override
  String get noDataAvailable => 'No data available for selected filters';

  @override
  String get applyFiltersToView => 'Apply filters to view dataset';

  @override
  String get aboutApp => 'About App';

  @override
  String get settings => 'Settings';

  @override
  String get menu => 'Menu';

  @override
  String get signInAsAuthority => 'Sign in as Authority';

  @override
  String get viewDataset => 'View Dataset';

  @override
  String get exploreFeatures => 'Explore Features';

  @override
  String get normal => 'Normal';

  @override
  String get suspicious => 'Suspicious';

  @override
  String get active => 'Active';

  @override
  String get healthy => 'HEALTHY';

  @override
  String get maintenance => 'MAINTENANCE';

  @override
  String get selectDate => 'Select date';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingDataset => 'Loading dataset...';

  @override
  String get downloading => 'Downloading...';

  @override
  String get reportGenerated => 'Report generated successfully!';
}
