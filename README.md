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
