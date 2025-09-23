// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'நிலத்தடி நீர் கண்காணிப்பான்';

  @override
  String get authorityDashboard => 'அதிகாரி டாஷ்போர்டு';

  @override
  String get authoritySignIn => 'அதிகாரி உள்நுழைவு';

  @override
  String get authorityRegistration => 'அதிகாரி பதிவு';

  @override
  String get welcome => 'வரவேற்கிறோம்';

  @override
  String get signIn => 'உள்நுழைக';

  @override
  String get signUp => 'பதிவு செய்க';

  @override
  String get signOut => 'வெளியேறுக';

  @override
  String get email => 'மின்னஞ்சல் முகவரி';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get dwlrStationId => 'டிடபிள்யுஎல்ஆர் நிலைய ஐடி';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டீர்களா?';

  @override
  String get demoCredentials =>
      'டெமோ அக்கிரடென்ஷியல்கள்:\nadmin@waterauthority.com / எந்த கடவுச்சொல்லும்';

  @override
  String get invalidCredentials =>
      'தவறான அக்கிரடென்ஷியல்கள். மீண்டும் முயற்சிக்கவும்.';

  @override
  String get accountCreated => 'கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டது!';

  @override
  String get emailExists =>
      'மின்னஞ்சல் ஏற்கனவே உள்ளது. வேறு மின்னஞ்சலைப் பயன்படுத்தவும்.';

  @override
  String get resetEmailSent =>
      'கடவுச்சொல் மீட்டமைப்பு மின்னஞ்சல் அனுப்பப்பட்டது! உங்கள் இன்பாக்ஸை சரிபார்க்கவும்.';

  @override
  String get enterEmailFirst =>
      'முதலில் உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்.';

  @override
  String get groundwaterMonitoring => 'நிலத்தடி நீர் கண்காணிப்பு பகுப்பாய்வு';

  @override
  String get selectYear => 'ஆண்டைத் தேர்ந்தெடுக்கவும்';

  @override
  String get trendAnalysis => 'போக்கு பகுப்பாய்வு';

  @override
  String waterLevelRainfallTrends(Object year) {
    return 'நீர் மட்டம் & மழைப்பொழிவு போக்குகள் (கடந்த 7 நாட்கள், $year)';
  }

  @override
  String get waterLevelPredictions => 'நீர் மட்டம் கணிப்புகள்';

  @override
  String get nextWeek => 'அடுத்த வாரம்';

  @override
  String get nextMonth => 'அடுத்த மாதம்';

  @override
  String get nextYear => 'அடுத்த ஆண்டு';

  @override
  String get rainfallForecast => 'மழைப்பொழிவு கணிப்பு';

  @override
  String get anomalyDetection => 'அசாதாரணம் கண்டறிதல்';

  @override
  String get systemStatus => 'கணினி நிலை';

  @override
  String get noUnusualReadings =>
      'கடந்த 24 மணி நேரத்தில் அசாதாரண வாசிப்புகள் எதுவும் கண்டறியப்படவில்லை';

  @override
  String get suspiciousReadings =>
      'கடந்த 24 மணி நேரத்தில் சந்தேகத்திற்குரிய வாசிப்புகள் கண்டறியப்பட்டன';

  @override
  String get stationHealthMonitoring => 'நிலைய சுகாதார கண்காணிப்பு';

  @override
  String get dwlrStationStatus => 'டிடபிள்யுஎல்ஆர் நிலைய நிலை';

  @override
  String get lastTransmission => 'கடைசி தரவு பரிமாற்றம்';

  @override
  String get reportsInsights => 'அறிக்கைகள் & நுண்ணறிவுகள்';

  @override
  String get generateMonthlyReport => 'மாதாந்திர அறிக்கையை உருவாக்குக';

  @override
  String get downloadPdfReport => 'PDF அறிக்கையை பதிவிறக்குக';

  @override
  String get viewDetailedDataset => 'விரிவான தரவுத்தொகுப்பைக் காண்க';

  @override
  String get filterDataset => 'தரவுத்தொகுப்பை வடிகட்டுக';

  @override
  String get selectLocation => 'இடத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get startDate => 'தொடக்க தேதி';

  @override
  String get endDate => 'முடிவு தேதி';

  @override
  String get applyFilters => 'வடிகட்டிகளைப் பயன்படுத்துக';

  @override
  String get clear => 'துடைக்க';

  @override
  String showingRecords(Object count) {
    return '$count பதிவுகள் காட்டப்படுகின்றன';
  }

  @override
  String get downloadCsv => 'CSV தரவுத்தொகுப்பை பதிவிறக்குக';

  @override
  String get downloadSuccessful => 'பதிவிறக்கம் வெற்றிகரமாக';

  @override
  String get noDataAvailable => 'தேர்ந்தெடுத்த வடிகட்டிகளுக்கு தரவு இல்லை';

  @override
  String get applyFiltersToView =>
      'தரவுத்தொகுப்பைக் காண வடிகட்டிகளைப் பயன்படுத்துக';

  @override
  String get aboutApp => 'பற்றி';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get menu => 'பட்டி';

  @override
  String get signInAsAuthority => 'அதிகாரியாக உள்நுழைக';

  @override
  String get viewDataset => 'தரவுத்தொகுப்பைக் காண்க';

  @override
  String get exploreFeatures => 'அம்சங்களை ஆராய்க';

  @override
  String get normal => 'சாதாரண';

  @override
  String get suspicious => 'சந்தேகத்திற்குரிய';

  @override
  String get active => 'செயலில்';

  @override
  String get healthy => 'ஆரோக்கியமான';

  @override
  String get maintenance => 'பராமரிப்பு';

  @override
  String get selectDate => 'தேதியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get loading => 'லோட் ஆகிறது...';

  @override
  String get loadingDataset => 'தரவுத்தொகுப்பு ஏற்றப்படுகிறது...';

  @override
  String get downloading => 'பதிவிறக்கப்படுகிறது...';

  @override
  String get reportGenerated => 'அறிக்கை வெற்றிகரமாக உருவாக்கப்பட்டது!';
}
