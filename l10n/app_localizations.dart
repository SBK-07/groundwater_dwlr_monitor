import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Groundwater Monitor'**
  String get appTitle;

  /// No description provided for @authorityDashboard.
  ///
  /// In en, this message translates to:
  /// **'Authority Dashboard'**
  String get authorityDashboard;

  /// No description provided for @authoritySignIn.
  ///
  /// In en, this message translates to:
  /// **'Authority Sign In'**
  String get authoritySignIn;

  /// No description provided for @authorityRegistration.
  ///
  /// In en, this message translates to:
  /// **'Authority Registration'**
  String get authorityRegistration;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dwlrStationId.
  ///
  /// In en, this message translates to:
  /// **'DWLR Station ID'**
  String get dwlrStationId;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo Credentials:\nadmin@waterauthority.com / any password'**
  String get demoCredentials;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get invalidCredentials;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreated;

  /// No description provided for @emailExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists. Please use a different email.'**
  String get emailExists;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get resetEmailSent;

  /// No description provided for @enterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address first.'**
  String get enterEmailFirst;

  /// No description provided for @groundwaterMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Groundwater Monitoring Analytics'**
  String get groundwaterMonitoring;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @trendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis'**
  String get trendAnalysis;

  /// No description provided for @waterLevelRainfallTrends.
  ///
  /// In en, this message translates to:
  /// **'Water Level & Rainfall Trends (Last 7 Days, {year})'**
  String waterLevelRainfallTrends(Object year);

  /// No description provided for @waterLevelPredictions.
  ///
  /// In en, this message translates to:
  /// **'Water Level Predictions'**
  String get waterLevelPredictions;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next Month'**
  String get nextMonth;

  /// No description provided for @nextYear.
  ///
  /// In en, this message translates to:
  /// **'Next Year'**
  String get nextYear;

  /// No description provided for @rainfallForecast.
  ///
  /// In en, this message translates to:
  /// **'Rainfall Forecast'**
  String get rainfallForecast;

  /// No description provided for @anomalyDetection.
  ///
  /// In en, this message translates to:
  /// **'Anomaly Detection'**
  String get anomalyDetection;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatus;

  /// No description provided for @noUnusualReadings.
  ///
  /// In en, this message translates to:
  /// **'No unusual readings detected in the last 24 hours'**
  String get noUnusualReadings;

  /// No description provided for @suspiciousReadings.
  ///
  /// In en, this message translates to:
  /// **'Suspicious readings detected in the last 24 hours'**
  String get suspiciousReadings;

  /// No description provided for @stationHealthMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Station Health Monitoring'**
  String get stationHealthMonitoring;

  /// No description provided for @dwlrStationStatus.
  ///
  /// In en, this message translates to:
  /// **'DWLR Station Status'**
  String get dwlrStationStatus;

  /// No description provided for @lastTransmission.
  ///
  /// In en, this message translates to:
  /// **'Last data transmission'**
  String get lastTransmission;

  /// No description provided for @reportsInsights.
  ///
  /// In en, this message translates to:
  /// **'Reports & Insights'**
  String get reportsInsights;

  /// No description provided for @generateMonthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Monthly Report'**
  String get generateMonthlyReport;

  /// No description provided for @downloadPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Report'**
  String get downloadPdfReport;

  /// No description provided for @viewDetailedDataset.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Dataset'**
  String get viewDetailedDataset;

  /// No description provided for @filterDataset.
  ///
  /// In en, this message translates to:
  /// **'Filter Dataset'**
  String get filterDataset;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @showingRecords.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} records'**
  String showingRecords(Object count);

  /// No description provided for @downloadCsv.
  ///
  /// In en, this message translates to:
  /// **'Download CSV Dataset'**
  String get downloadCsv;

  /// No description provided for @downloadSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Download Successful'**
  String get downloadSuccessful;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available for selected filters'**
  String get noDataAvailable;

  /// No description provided for @applyFiltersToView.
  ///
  /// In en, this message translates to:
  /// **'Apply filters to view dataset'**
  String get applyFiltersToView;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @signInAsAuthority.
  ///
  /// In en, this message translates to:
  /// **'Sign in as Authority'**
  String get signInAsAuthority;

  /// No description provided for @viewDataset.
  ///
  /// In en, this message translates to:
  /// **'View Dataset'**
  String get viewDataset;

  /// No description provided for @exploreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Explore Features'**
  String get exploreFeatures;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @suspicious.
  ///
  /// In en, this message translates to:
  /// **'Suspicious'**
  String get suspicious;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'HEALTHY'**
  String get healthy;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'MAINTENANCE'**
  String get maintenance;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingDataset.
  ///
  /// In en, this message translates to:
  /// **'Loading dataset...'**
  String get loadingDataset;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @reportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Report generated successfully!'**
  String get reportGenerated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
