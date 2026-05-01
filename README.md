# 💧 Groundwater DWLR Monitor

> A cross-platform Flutter application for real-time groundwater level monitoring, trend analysis, anomaly detection, and predictive analytics using Digital Water Level Recorder (DWLR) station data.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![fl_chart](https://img.shields.io/badge/fl__chart-1.1.1-FF6B6B?logo=flutter&logoColor=white)](https://pub.dev/packages/fl_chart)
[![Google Fonts](https://img.shields.io/badge/Google%20Fonts-6.3-4285F4?logo=google&logoColor=white)](https://pub.dev/packages/google_fonts)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20Linux%20%7C%20macOS-informational)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📌 Problem Statement / Objective

India faces a critical groundwater depletion crisis — with over-extraction, irregular rainfall, and climate variability accelerating the decline in aquifer levels. Manual monitoring of DWLR (Digital Water Level Recorder) stations is resource-intensive, delayed, and prone to data gaps.

**This application addresses:**
- The need for a centralized, accessible groundwater monitoring interface for field authorities and public stakeholders.
- Lack of real-time visualization and trend analysis tools for DWLR station data.
- Absence of an early-warning system for anomalous water level behavior.
- Difficulty in correlating rainfall, temperature, pH, and dissolved oxygen data with groundwater levels for actionable insights.

**Objective:** Deliver a production-ready, multi-platform monitoring application that enables water authorities to track DWLR station health, visualize multi-parameter trends, detect anomalies, and generate predictive forecasts — all from a unified dashboard.

---

## ✨ Features

- **🌊 Real-Time DWLR Data Visualization** — Interactive line charts for water level and rainfall trends across multiple monitoring locations.
- **📊 Multi-Parameter Monitoring** — Tracks water level (m), rainfall (mm), temperature (°C), pH level, dissolved oxygen, and anomaly/station status.
- **🔒 Role-Based Access Control** — Separate public (home) view and authenticated Authority Dashboard with station-specific data access.
- **🚨 Anomaly Detection** — Automatic flagging of suspicious readings with real-time system health status indicators.
- **📈 Predictive Analytics** — Computes short-term (weekly/monthly/annual) water level forecasts and rainfall projections using historical averages.
- **📋 Dataset Explorer** — Filterable, paginated dataset view with location and date-range filters for data auditing.
- **📄 Report Generation** — One-click monthly report download capability for operational record-keeping.
- **🏥 Station Health Monitoring** — Live DWLR station status (Active/Maintenance) with last data transmission timestamp.
- **📱 Cross-Platform** — Runs on Android, iOS, Web, Windows, macOS, and Linux from a single codebase.
- **🎨 Modern UI/UX** — Gradient-themed Material 3 interface with smooth page transitions and Google Fonts typography.

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Framework** | Flutter 3.x | Cross-platform UI framework |
| **Language** | Dart 3.7+ | Application logic and state management |
| **Charting** | fl_chart 1.1.1 | Interactive line charts and data visualizations |
| **Typography** | google_fonts 6.3.1 | Consistent, professional font rendering (Poppins) |
| **Internationalization** | intl 0.20.2 | Date/time formatting and locale support |
| **State Management** | Flutter StatefulWidget | Local reactive state management |
| **Authentication** | Mock Auth Service (Singleton) | Role-based auth simulation (extensible to Firebase) |
| **Data Layer** | Hardcoded dataset (DWLR CSV-derived) | Structured groundwater historical records |
| **Build Tools** | Flutter CLI / CMake | Multi-platform compilation (Android, iOS, Web, Desktop) |
| **Linting** | flutter_lints 6.0.0 | Static analysis and code quality enforcement |

---

## 🏗️ System Architecture / Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    DWLR Monitor App                          │
│                                                             │
│  ┌──────────────┐     ┌──────────────────────────────────┐  │
│  │  Home Screen │     │     Authority Dashboard          │  │
│  │  (Public)    │     │  (Role-Based Authenticated View) │  │
│  │              │     │                                  │  │
│  │  ▸ Hero View │     │  ▸ Station-Specific Data Filter  │  │
│  │  ▸ Chart     │     │  ▸ Trend Analysis (7-day charts) │  │
│  │    Carousel  │     │  ▸ Predictive Forecasts          │  │
│  │  ▸ Side Menu │     │  ▸ Anomaly Detection Status      │  │
│  └──────┬───────┘     │  ▸ Station Health Monitor        │  │
│         │             │  ▸ PDF Report Generation         │  │
│         │             └──────────────┬───────────────────┘  │
│         │                            │                      │
│  ┌──────▼────────────────────────────▼───────────────────┐  │
│  │                  Data Layer                           │  │
│  │  ┌─────────────────────┐  ┌────────────────────────┐  │  │
│  │  │  GroundwaterData    │  │  MockAuthService        │  │  │
│  │  │  Model              │  │  (Singleton)            │  │  │
│  │  │  - waterLevel       │  │  - signIn / signUp      │  │  │
│  │  │  - rainfall         │  │  - currentUser          │  │  │
│  │  │  - temperature      │  │  - session management   │  │  │
│  │  │  - pHLevel          │  └────────────────────────┘  │  │
│  │  │  - dissolvedOxygen  │                              │  │
│  │  │  - anomalyStatus    │  ┌────────────────────────┐  │  │
│  │  │  - stationStatus    │  │  Hardcoded Dataset      │  │  │
│  │  │  - location         │  │  (CGL, Chennai,         │  │  │
│  │  └─────────────────────┘  │   Madurai, Nilgiris,    │  │  │
│  │                           │   Cuddalore)            │  │  │
│  │                           └────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**Data Flow:**
1. Groundwater sensor readings (water level, rainfall, pH, temperature, DO) are recorded by DWLR stations.
2. Station data is ingested into the application's data layer (currently structured hardcoded data; designed for future API/Firebase integration).
3. The Home Screen displays a public-facing chart carousel with real-time data for the default location (CGL/Chengalpet).
4. Authenticated authorities access the dashboard, filtered to their assigned DWLR station, with trend charts, forecasts, and anomaly alerts.
5. The Dataset Page allows granular exploration with location and date-range filters.

---

## ⚙️ Installation & Setup

### Prerequisites

| Requirement | Version |
|-------------|---------|
| Flutter SDK | ≥ 3.7.0 |
| Dart SDK | ≥ 3.7.0 |
| Android Studio / VS Code | Latest |
| Android SDK (for Android) | API 21+ |
| Xcode (for iOS/macOS) | 14+ |

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/SBK-07/groundwater_dwlr_monitor.git
cd groundwater_dwlr_monitor

# 2. Install Flutter dependencies
flutter pub get

# 3. Verify Flutter environment
flutter doctor

# 4. Run on a connected device or emulator
flutter run

# 5. Build for a specific platform
flutter build apk          # Android APK
flutter build ios          # iOS (requires macOS + Xcode)
flutter build web          # Web
flutter build windows      # Windows Desktop
```

---

## 🚀 Usage

### Public View (Home Screen)
1. Launch the app — the **Home Screen** loads with a hero banner and data chart carousel.
2. Swipe through the carousel to explore **Water Level**, **Rainfall**, **Temperature**, and **pH/Dissolved Oxygen** charts for the Chengalpet (CGL) DWLR station.
3. Tap the **☰ Menu** icon to access:
   - **Sign in as Authority** — Role-based login for water department officials.
   - **View Dataset** — Browse filtered historical data records.
   - **About App** — Application information.

### Authority Dashboard
1. Navigate to **Sign in as Authority** from the side menu.
2. Sign in using authority credentials (demo accounts pre-seeded):
   - `admin@waterauthority.com` / any password
   - `inspector@waterauthority.com` / any password
3. The dashboard shows:
   - **Station Assignment** — Data filtered to the logged-in authority's DWLR station.
   - **Year Selector** — Filter trends by 2022, 2023, or 2024.
   - **7-Day Trend Charts** — Overlaid water level and rainfall line charts.
   - **Predictive Forecasts** — Projected water level for next week, month, and year.
   - **Anomaly Status** — Real-time flag for suspicious readings.
   - **Station Health** — DWLR sensor operational status.
   - **Report Download** — Generate and download monthly PDF reports.

### Dataset Explorer
1. Access via **View Dataset** from the side menu or Authority Dashboard.
2. Select a **Location** (Chennai, Chengalpet, Madurai, Nilgiris, Cuddalore).
3. Set a **Start Date** and **End Date** range.
4. Tap **Apply Filters** to retrieve matching records.
5. Browse the tabular data with all sensor parameters.

---

## 📸 Screenshots / Demo

> _Screenshots to be added. Run the app locally to preview the UI, or refer to the chart and dashboard descriptions in the [Usage](#-usage) section._

| Screen | Description |
|--------|-------------|
| Home Screen | Hero banner with gradient AppBar and swipeable chart carousel |
| Chart Carousel | Interactive line charts for water level, rainfall, temperature, and pH/DO |
| Side Navigation Menu | Slide-in drawer with authority sign-in and dataset access |
| Authority Dashboard | Station-specific trend charts, predictions, anomaly detection, and health status |
| Dataset Explorer | Filterable tabular view of historical DWLR readings |
| Sign In / Sign Up | Authority credential screens with form validation |

---

## 🔌 API Integration

> **Current Status:** The application uses a structured in-memory dataset (`hardcoded_data.dart`) sourced from DWLR station records. The architecture is designed for seamless migration to live data sources.

**Planned Integration Points:**

| Integration | Technology | Status |
|------------|-----------|--------|
| Real-time DWLR data feed | REST API / WebSocket | 🔜 Planned |
| Cloud authentication | Firebase Auth | 🔜 Planned |
| Remote data storage | Firebase Firestore / PostgreSQL | 🔜 Planned |
| PDF report generation | `pdf` / `printing` Flutter packages | 🔜 Planned |
| Push notifications for anomalies | Firebase Cloud Messaging | 🔜 Planned |
| Government DWLR data API | India-WRIS / CWC Open Data | 🔜 Planned |

The `MockAuthService` singleton and `getHardcodedData()` abstraction are designed as drop-in replacement points for real API service clients.

---

## 📁 Folder Structure

```
groundwater_dwlr_monitor/
├── lib/
│   ├── main.dart                        # App entry point
│   ├── data/
│   │   └── hardcoded_data.dart          # Structured DWLR sensor dataset
│   ├── models/
│   │   ├── groundwater_data.dart        # GroundwaterData domain model
│   │   └── mock_user.dart               # MockUser domain model
│   ├── services/
│   │   └── mock_auth_service.dart       # Authentication singleton service
│   ├── screens/
│   │   ├── home_screen.dart             # Public landing page with chart carousel
│   │   ├── authority_dashboard.dart     # Authenticated analytics dashboard
│   │   ├── authority_sign_in_page.dart  # Authority login screen
│   │   ├── authority_sign_up_page.dart  # Authority registration screen
│   │   ├── dataset_page.dart            # Filterable historical dataset view
│   │   ├── settings_page.dart           # App settings screen
│   │   └── about_page.dart              # App information screen
│   └── widgets/
│       └── swipable_container.dart      # Swipeable chart carousel widget
├── android/                             # Android platform configuration
├── ios/                                 # iOS platform configuration
├── web/                                 # Web platform configuration
├── windows/                             # Windows desktop configuration
├── linux/                               # Linux desktop configuration
├── macos/                               # macOS desktop configuration
├── test/
│   └── widget_test.dart                 # Widget unit tests
├── pubspec.yaml                         # Flutter project manifest & dependencies
├── analysis_options.yaml               # Dart static analysis rules
└── README.md
```

---

## 🚀 Future Enhancements / Roadmap

| Enhancement | Description |
|------------|-------------|
| **Live API Integration** | Connect to India-WRIS / CWC DWLR data feeds for real-time monitoring |
| **Firebase Backend** | Replace mock auth and in-memory data with Firebase Auth + Firestore |
| **ML-Based Anomaly Detection** | Train an LSTM or Isolation Forest model on DWLR time-series for predictive alerting |
| **Push Notifications** | FCM-based alerts for critical water level thresholds or station failures |
| **PDF Report Export** | Full formatted monthly reports with charts, statistics, and authority sign-off |
| **Multi-Station Dashboard** | Aggregate view across all DWLR stations with map-based drill-down |
| **Offline Mode** | Local caching of recent sensor data for field use in low-connectivity areas |
| **Dark Mode** | Adaptive theme support for the full application |
| **Data Export (CSV/Excel)** | Allow authorities to export filtered datasets for external analysis |
| **Localization (Tamil / Hindi)** | Regional language support for field personnel in Tamil Nadu |

---

## 🤝 Contributing

Contributions are welcome! Please follow the guidelines below to maintain code quality and consistency.

1. **Fork** the repository and create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Follow** the existing code style — use `flutter analyze` and ensure no linting errors:
   ```bash
   flutter analyze
   flutter test
   ```

3. **Commit** with clear, descriptive messages:
   ```bash
   git commit -m "feat: add real-time Firebase Firestore integration"
   ```

4. **Push** to your fork and open a **Pull Request** against `main`.

5. Ensure your PR includes:
   - A clear description of the change and its purpose.
   - Test coverage for new functionality.
   - No breaking changes to existing screens or models (or a migration path if unavoidable).

> For major changes, please open an issue first to discuss the proposed modification.

---

## 📄 License

This project is licensed under the **MIT License**.  
See the [LICENSE](LICENSE) file for full details.

---

## 👤 Author / Contact

**SBK-07**

- GitHub: [@SBK-07](https://github.com/SBK-07)
- Repository: [groundwater_dwlr_monitor](https://github.com/SBK-07/groundwater_dwlr_monitor)

---

> *Built with Flutter · Designed for water resource management authorities and environmental monitoring applications.*
