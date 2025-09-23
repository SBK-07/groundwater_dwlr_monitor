// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'भूजल मॉनिटर';

  @override
  String get authorityDashboard => 'अधिकारी डैशबोर्ड';

  @override
  String get authoritySignIn => 'अधिकारी लॉगिन';

  @override
  String get authorityRegistration => 'अधिकारी पंजीकरण';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get signIn => 'लॉगिन करें';

  @override
  String get signUp => 'रजिस्टर करें';

  @override
  String get signOut => 'लॉगआउट करें';

  @override
  String get email => 'ईमेल पता';

  @override
  String get password => 'पासवर्ड';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get dwlrStationId => 'डीडब्ल्यूएलआर स्टेशन आईडी';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get demoCredentials =>
      'डेमो क्रेडेंशियल्स:\nadmin@waterauthority.com / कोई भी पासवर्ड';

  @override
  String get invalidCredentials => 'गलत क्रेडेंशियल्स। कृपया पुनः प्रयास करें।';

  @override
  String get accountCreated => 'खाता सफलतापूर्वक बनाया गया!';

  @override
  String get emailExists =>
      'ईमेल पहले से मौजूद है। कृपया दूसरा ईमेल प्रयोग करें।';

  @override
  String get resetEmailSent =>
      'पासवर्ड रीसेट ईमेल भेजा गया! अपना इनबॉक्स चेक करें।';

  @override
  String get enterEmailFirst => 'कृपया पहले अपना ईमेल पता दर्ज करें।';

  @override
  String get groundwaterMonitoring => 'भूजल मॉनिटरिंग एनालिटिक्स';

  @override
  String get selectYear => 'वर्ष चुनें';

  @override
  String get trendAnalysis => 'ट्रेंड विश्लेषण';

  @override
  String waterLevelRainfallTrends(Object year) {
    return 'जल स्तर और वर्षा के रुझान (पिछले 7 दिन, $year)';
  }

  @override
  String get waterLevelPredictions => 'जल स्तर पूर्वानुमान';

  @override
  String get nextWeek => 'अगले सप्ताह';

  @override
  String get nextMonth => 'अगले महीने';

  @override
  String get nextYear => 'अगले साल';

  @override
  String get rainfallForecast => 'वर्षा पूर्वानुमान';

  @override
  String get anomalyDetection => 'अनियमितता पहचान';

  @override
  String get systemStatus => 'सिस्टम स्थिति';

  @override
  String get noUnusualReadings =>
      'पिछले 24 घंटों में कोई असामान्य रीडिंग नहीं मिली';

  @override
  String get suspiciousReadings => 'पिछले 24 घंटों में संदिग्ध रीडिंग मिली';

  @override
  String get stationHealthMonitoring => 'स्टेशन स्वास्थ्य मॉनिटरिंग';

  @override
  String get dwlrStationStatus => 'डीडब्ल्यूएलआर स्टेशन स्थिति';

  @override
  String get lastTransmission => 'अंतिम डेटा ट्रांसमिशन';

  @override
  String get reportsInsights => 'रिपोर्ट्स और इनसाइट्स';

  @override
  String get generateMonthlyReport => 'मासिक रिपोर्ट जनरेट करें';

  @override
  String get downloadPdfReport => 'PDF रिपोर्ट डाउनलोड करें';

  @override
  String get viewDetailedDataset => 'विस्तृत डेटासेट देखें';

  @override
  String get filterDataset => 'डेटासेट फिल्टर करें';

  @override
  String get selectLocation => 'स्थान चुनें';

  @override
  String get startDate => 'प्रारंभ तिथि';

  @override
  String get endDate => 'समाप्ति तिथि';

  @override
  String get applyFilters => 'फिल्टर लागू करें';

  @override
  String get clear => 'साफ करें';

  @override
  String showingRecords(Object count) {
    return '$count रिकॉर्ड दिखाए जा रहे हैं';
  }

  @override
  String get downloadCsv => 'CSV डेटासेट डाउनलोड करें';

  @override
  String get downloadSuccessful => 'डाउनलोड सफल';

  @override
  String get noDataAvailable => 'चयनित फिल्टर के लिए कोई डेटा उपलब्ध नहीं है';

  @override
  String get applyFiltersToView => 'डेटासेट देखने के लिए फिल्टर लागू करें';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get menu => 'मेन्यू';

  @override
  String get signInAsAuthority => 'अधिकारी के रूप में लॉगिन करें';

  @override
  String get viewDataset => 'डेटासेट देखें';

  @override
  String get exploreFeatures => 'फीचर्स एक्सप्लोर करें';

  @override
  String get normal => 'सामान्य';

  @override
  String get suspicious => 'संदिग्ध';

  @override
  String get active => 'सक्रिय';

  @override
  String get healthy => 'स्वस्थ';

  @override
  String get maintenance => 'रखरखाव';

  @override
  String get selectDate => 'तिथि चुनें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get loadingDataset => 'डेटासेट लोड हो रहा है...';

  @override
  String get downloading => 'डाउनलोड हो रहा है...';

  @override
  String get reportGenerated => 'रिपोर्ट सफलतापूर्वक जनरेट की गई!';
}
