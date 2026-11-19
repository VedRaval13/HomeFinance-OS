# 🏠 HomeFinance OS

<p align="center">
  <strong>A 100% On-Device, Privacy-First Personal & Family Financial Operating System</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.29+-02569B?logo=flutter&logoColor=white" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white" alt="Dart Version" />
  <img src="https://img.shields.io/badge/Architecture-Local--First-2E7D32" alt="Local First" />
  <img src="https://img.shields.io/badge/Tests-79%2F79%20Passing%20(100%25)-brightgreen" alt="Tests" />
  <img src="https://img.shields.io/badge/Security-OWASP%20Hardened-blue" alt="Security" />
  <img src="https://img.shields.io/badge/Platforms-Android%20|%20Web%20|%20Windows%20|%20iOS%20|%20macOS-informational" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-orange" alt="License" />
</p>

---

## 🌟 Overview

**HomeFinance OS** is a modern, cross-platform financial operating system designed for households and individuals who value **absolute financial privacy**, **mathematical accuracy**, and **intelligent financial coaching**.

Unlike traditional finance apps that upload your sensitive banking and spending data to third-party cloud servers, **HomeFinance OS operates 100% on your device**. Your financial ledger, accounts, budgets, and family contributions never leave your hardware.

---

## ✨ Key Features

### 🧠 100% On-Device AI Financial Recommendation Engine
Six autonomous financial intelligence modules analyze your trailing transaction patterns purely on-device without cloud LLMs or external APIs:

1. **Budget Pacing Engine**: Tracks elapsed days in the billing cycle against real expenditure velocity, projecting end-of-month runway and predicting overspends before they occur.
2. **Anomaly & Spike Detector**: Computes dynamic standard deviation bands ($1.8\sigma$ / $2.8\sigma$) per category to flag statistical outliers, abnormal transaction spikes, and accidental double-charges.
3. **Goal Velocity Forecaster**: Calculates rolling daily savings velocity to project precise milestone completion dates and recommend required daily acceleration amounts.
4. **Subscription & Silent Cash Leak Detector**: Identifies recurring billing cycles (weekly, monthly, annual) and alerts you to silent recurring fee drains.
5. **Liquidity Runway Calculator**: Assesses true liquid reserves against average 30-day burn rate, warning when cash reserves drop below the 3-to-6 month emergency threshold.
6. **50/30/20 Structural Budget Rule**: Evaluates total monthly expenditures against the classic 50% Needs / 30% Wants / 20% Savings benchmark.

---

### 🔄 Dual Financial Scopes (Household vs. Personal)
* **Floating Segmented Capsule Switcher**: Seamlessly toggle between **🏠 Household Scope** (shared family expenses, pooled budgets, utility contributions) and **👤 Personal Space** (private individual accounts and budgets).
* **Multi-Member Attribution**: Track who spent what, calculate monthly family member contributions, and process member reimbursements with atomic ledger updates.

---

### 🛡️ Enterprise-Grade Security & Privacy
* **Zero Cloud / Zero Telemetry**: No tracking SDKs, ad networks, or background telemetry. Dynamic external font downloading is disabled at runtime to guarantee zero IP address leakage.
* **Master App Lock**: 4-digit or 6-digit Master PIN combined with biometric authentication (Fingerprint / Face ID).
* **Brute-Force Rate Limiting**: Enforces progressive security timeouts:
  - 5 failed attempts $\rightarrow$ 30-second lockout with realtime countdown.
  - 10 failed attempts $\rightarrow$ 5-minute lockout.
* **Android `FLAG_SECURE`**: Prevents screen recording, screenshots, and OS task-switcher thumbnail caching.
* **Encrypted Backups (`.hfbk`)**: Encrypt-then-MAC authenticated encryption using **PBKDF2** (100,000 rounds) + **HMAC-SHA256 Counter Mode**, verified with constant-time comparison.

---

### 📐 Mathematical Integrity
* **Integer-Paise Precision (`Money` Value Object)**: Floating-point numbers (`double`) are strictly prohibited in the financial domain model. All currency values are stored in minor currency units (paise: ₹1.00 = `100`), eliminating IEEE-754 rounding drift.

---

### 📱 Responsive Cross-Platform UI
* **Mobile (< 600px)**: Compact touch targets ($\ge 38\text{px}$), micro-avatar chips, stacked responsive cards.
* **Tablet & Foldables (600px – 840px)**: Two-column responsive analytics grid.
* **Desktop & Web ($\ge 840\text{px}$)**: Adaptive `NavigationRail`, centered `maxWidth: 1200` canvas constraint, and WebAssembly-backed SQLite execution.

---

## 🏗️ Architecture & Tech Stack

HomeFinance OS is built using **Feature-First Clean Architecture** with unidirectional data flow and reactive database streams.

### 📐 High-Level Architecture Flow

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Flutter Material 3 Screens, Widgets, Controllers)   │
└───────────────────────────┬────────────────────────────┘
                            │ Watches / Triggers
                            ▼
┌────────────────────────────────────────────────────────┐
│             State Management (Riverpod)                │
│    (Scope State, StreamProviders, Notifiers, Enums)    │
└───────────────────────────┬────────────────────────────┘
                            │ Reads / Writes
                            ▼
┌────────────────────────────────────────────────────────┐
│               Domain & Core Business Logic             │
│ (Money Value Object, 6 AI Insights Engines, Security) │
└───────────────────────────┬────────────────────────────┘
                            │ Queries / Mutates
                            ▼
┌────────────────────────────────────────────────────────┐
│            Data Layer (Drift SQLite ORM)               │
│      (Type-Safe DAOs, Migrations, Reactive Streams)    │
└───────────────────────────┬────────────────────────────┘
                            │ Platform Connection Bridge
             ┌──────────────┴──────────────┐
             ▼                             ▼
┌─────────────────────────┐   ┌──────────────────────────┐
│ Native Platforms (FFI)  │   │  Web Platform (WASM)     │
│ Android, Windows, macOS │   │  Chrome, Edge, Safari    │
│ SQLite via dart:ffi     │   │  sqlite3.wasm + Worker   │
│ WAL Mode Journaling     │   │  IndexedDB Persistence   │
└─────────────────────────┘   └──────────────────────────┘
```

### 📂 Directory Structure

```
lib/
├── app.dart                                # MaterialApp.router root with AppLockGate
├── main.dart                               # Edge-to-edge system UI, zero-telemetry init
├── core/
│   ├── constants/                          # AppColors, AppDimensions, AppStrings
│   ├── database/                           # Drift SQLite ORM
│   │   ├── connection/                     # Conditional connection bridge
│   │   │   ├── open_connection.dart        # Platform export router
│   │   │   ├── open_connection_native.dart # Native FFI SQLite (WAL mode)
│   │   │   ├── open_connection_web.dart    # WebAssembly SQLite (sqlite3.wasm)
│   │   │   └── open_connection_stub.dart   # Cross-compilation fallback stub
│   │   ├── daos/                           # Type-safe DAOs (Accounts, Budgets, Ledger, etc.)
│   │   ├── tables/                         # Drift table schema definitions
│   │   └── seeders/                        # Default seeders (Categories, Members, Accounts)
│   ├── models/                             # FinancialScope, Money value object, Enums
│   ├── security/                           # AppLockService, BackupCrypto, BackupService
│   │   ├── backup/                         # PBKDF2 + HMAC-SHA256 authenticated encryption
│   │   ├── presentation/                   # AppLockGate, AppLockScreen, lockout UI
│   │   └── services/                       # Hardware keystore & biometric auth
│   ├── theme/                              # Light/Dark Material 3 Themes, Typography
│   └── utils/                              # Date formatters, currency helpers
├── features/
│   ├── accounts/                           # Multi-account management & net worth
│   ├── budgets/                            # Category spending limits & savings goals
│   ├── dashboard/                          # Analytics charts (Pie chart, Bar chart)
│   ├── family_members/                     # Family member profiles & roles
│   ├── finance_spaces/                     # Active scope state management
│   ├── insights/                           # 6 On-Device AI Recommendation Engines
│   │   └── presentation/                   # Modular recommendation cards & widgets
│   ├── navigation/                         # GoRouter router & NavigationRail shell
│   ├── settings/                           # Security, PIN config, encrypted backup/restore
│   ├── transactions/                       # Ledger, filtering, add/edit modal
│   └── transfers/                          # Atomic account-to-account transfers
└── shared/
    └── widgets/                            # AppCard, MoneyDisplay, ScopeCapsule
```

### 🛠️ Technology Stack Breakdown

| Category | Technology | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | 3.29+ | Cross-platform Material 3 responsive UI engine |
| **Language** | [Dart](https://dart.dev) | 3.5+ | Sound null-safe compiled application language |
| **State Management** | [Riverpod](https://riverpod.dev) | `^2.6.1` | Compile-safe, testable, unidirectional state management |
| **Routing & Navigation** | [GoRouter](https://pub.dev/packages/go_router) | `^14.8.1` | Declarative URL-based and deep-linkable router |
| **Local Database Engine** | [Drift](https://drift.simonbinder.eu) | `^2.24.2` | Type-safe reactive SQLite ORM with auto-migrations |
| **Native Database Bridge** | `drift/native.dart` | `^2.24.2` | High-performance C SQLite binding via `dart:ffi` with WAL mode |
| **Web Database Engine** | `drift/wasm.dart` | `^2.24.2` | WebAssembly SQLite binary (`sqlite3.wasm`) with web worker persistence |
| **Data Visualization** | [FL Chart](https://pub.dev/packages/fl_chart) | `^0.70.2` | Hardware-accelerated financial charts & graphs |
| **Biometric Auth** | [local_auth](https://pub.dev/packages/local_auth) | `^2.3.0` | Native Fingerprint, Touch ID, and Face ID hardware prompts |
| **Secure Key Storage** | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | `^9.2.4` | Android Keystore & iOS Keychain hardware encryption |
| **Cryptography** | [crypto](https://pub.dev/packages/crypto) | `^3.0.6` | Standard PBKDF2, HMAC-SHA256, and constant-time equality |
| **Build Automation** | [build_runner](https://pub.dev/packages/build_runner) | `^2.4.15` | Code generation for Drift database tables and DAOs |

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.24.0`)
* [Dart SDK](https://dart.dev/get-dart) (`>= 3.5.0`)
* Java 17+ (for Android builds)
* Google Chrome or Microsoft Edge (for Web builds)

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/house-os.git
cd house-os
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Database Code (Drift)
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🧪 Running the Test Suite

HomeFinance OS includes **79 automated test suites** covering financial arithmetic, encrypted backups, all 6 AI recommendation modules, brute-force security lockout, and end-to-end user workflows:

```bash
flutter test --no-pub
```

### Run Static Analysis
```bash
flutter analyze lib test
```

---

## 💻 Running the App

### Android Device / Emulator
```bash
flutter run -d android
```

### Web Browser (Chrome / Edge)
```bash
flutter run -d chrome
# or
flutter run -d edge
```

### Windows Desktop
```bash
flutter run -d windows
```

---

## 📦 Building Production Binaries

### Android Release APK (R8 Obfuscated)
```bash
flutter build apk --release
```
The optimized and shrunk APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

### Web Production Bundle
```bash
flutter build web --release
```
The optimized web distribution will be generated at:
`build/web/`

---

## 🔐 Security Audit & Penetration Testing

HomeFinance OS has been verified against the **OWASP Mobile Application Security Verification Standard (MASVS v2.0)**:

* ✅ **MASVS-AUTH-2**: Progressive PIN lockout & brute-force prevention (30s after 5 attempts, 5min after 10 attempts).
* ✅ **MASVS-STORAGE-2**: In-memory screenshot prevention (`FLAG_SECURE`) & Android `allowBackup="false"`.
* ✅ **MASVS-CRYPTO-1**: 100,000-iteration PBKDF2 key derivation with Encrypt-then-MAC authentication.
* ✅ **MASVS-CODE-1**: R8 bytecode minification & native ProGuard preservation rules.

Full penetration test report: [penetration_test_report.md](file:///C:/Users/vedra/.gemini/antigravity/brain/418c86a0-9495-4919-92e6-ba5671a61c5d/penetration_test_report.md)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
