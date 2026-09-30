# ProPersona — The ATS Friendly CV Maker

<p align="center">
  <strong>Build Better Resumes. Improve ATS Compatibility. Present Your Professional Story with Confidence.</strong>
</p>

<p align="center">
  An AI-powered, cross-platform career development platform by <strong>Huzentra Technologies</strong>.
</p>

<p align="center">
  <em>Building Technology. Creating Possibilities.</em>
</p>

---

## Project Status

> **Active Development — Foundation Complete**

ProPersona has successfully completed **Phase 0 — Architecture & Foundation**.

The project is now moving into:

**Phase 1 — Authentication & Onboarding**

The application is currently under active development and is **not yet production-ready**.

---

## Table of Contents

- [About ProPersona](#about-propersona)
- [Product Vision](#product-vision)
- [Core Objectives](#core-objectives)
- [Planned Features](#planned-features)
- [Current Development Status](#current-development-status)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Firebase Architecture](#firebase-architecture)
- [Firestore Data Model](#firestore-data-model)
- [Security Architecture](#security-architecture)
- [Responsive Design](#responsive-design)
- [Design System](#design-system)
- [Result & Error Handling](#result--error-handling)
- [Base Services](#base-services)
- [Routing Architecture](#routing-architecture)
- [File & PDF Strategy](#file--pdf-strategy)
- [Planned AI Architecture](#planned-ai-architecture)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [Development Commands](#development-commands)
- [Development Roadmap](#development-roadmap)
- [Development Guidelines](#development-guidelines)
- [Security Principles](#security-principles)
- [Contributing](#contributing)
- [License](#license)
- [About Huzentra Technologies](#about-huzentra-technologies)
- [Contact](#contact)

---

# About ProPersona

**ProPersona — The ATS Friendly CV Maker** is a cross-platform career development application designed to help fresh graduates and professionals create, manage, analyze, and optimize professional resumes.

The application is being developed with **Flutter** and is designed around structured resume data rather than treating a resume as only a static document.

This allows resume information to be:

- Created once
- Edited easily
- Reused across templates
- Optimized with AI
- Compared against job descriptions
- Analyzed for ATS compatibility
- Converted into professional PDFs
- Used for generating cover letters
- Managed across multiple devices

ProPersona is developed under:

**Huzentra Technologies**

---

# Product Vision

ProPersona aims to become an intelligent career-document platform that combines:

- Professional resume building
- ATS optimization
- AI-assisted writing
- Job-description analysis
- Career-stage-aware experiences
- Professional PDF generation
- Cross-platform accessibility

The goal is to help users present their experience clearly, professionally, and in a format suitable for modern recruitment systems.

---

# Core Objectives

## Intelligent Resume Generation

Transform structured career information into professional, ATS-friendly resumes.

## Career-Aware Onboarding

Users will be categorized according to their career stage:

```text
graduate
professional
```

The application can then adapt resume suggestions, templates, and AI behavior accordingly.

## ATS Optimization

Analyze resume content against job descriptions and provide actionable feedback.

## Cross-Platform Experience

Deliver a consistent experience across:

- Android
- iOS
- Web
- Windows
- macOS

## Responsive User Interface

Use a custom responsive system and BentoGrid architecture that adapts across mobile, tablet, desktop, and web layouts.

## Secure User Data

Use Firebase Authentication, Firestore Security Rules, repository isolation, and backend-authoritative data for sensitive operations.

---

# Planned Features

## Resume Builder

The resume builder is planned to support:

- Personal Information
- Professional Summary
- Education
- Work Experience
- Skills
- Projects
- Certifications
- Languages
- Custom Sections

Resume data will remain independent from presentation templates.

```text
Resume Data
     ↓
Template
     ↓
PDF Layout Engine
     ↓
Professional Resume
```

This allows users to switch templates without recreating their information.

---

## AI Resume Optimization

Planned AI capabilities include:

- Professional summary generation
- Resume bullet rewriting
- Action verb improvements
- Achievement-focused writing
- Keyword optimization
- Skills suggestions
- Resume section improvements
- Role-specific recommendations

AI credentials will **never be exposed inside the Flutter application**.

---

## ATS Analyzer

Users will be able to compare a resume against a target job description.

Planned analysis includes:

- Overall ATS Score
- Keyword Match Score
- Skills Match
- Experience Match
- Formatting Score
- Matched Keywords
- Missing Keywords
- Resume Strengths
- Improvement Recommendations

---

## Bullet Point Polish

ProPersona will help users transform weak resume statements into achievement-focused bullet points.

One of the writing approaches supported by the application will be the **XYZ formula**:

> Accomplished **X**, as measured by **Y**, by doing **Z**.

---

## Cover Letter Generator

Users will eventually be able to generate professional cover letters using:

- Resume information
- Target job title
- Company name
- Job description
- Career stage
- Relevant experience and skills

---

## PDF Generation

Professional resume PDFs will be generated locally/on-demand.

The intended pipeline is:

```text
ResumeModel
     ↓
Resume Template
     ↓
PDF Layout Engine
     ↓
PDF Preview
     ↓
Save / Share / Print
```

Permanent cloud storage is not required for generated PDFs in ProPersona V1.

---

# Career Stages

## Graduate

Designed for:

- Students
- Fresh graduates
- Entry-level candidates
- Internship applicants

The application can prioritize:

- Education
- Academic projects
- Internships
- Skills
- Certifications
- Coursework

---

## Professional

Designed for candidates with professional work experience.

The application can prioritize:

- Employment history
- Professional achievements
- Career progression
- Industry experience
- Leadership
- Technical and professional skills

Internally, stable machine-readable values are used:

```text
graduate
professional
```

---

# Current Development Status

## Phase 0 — Architecture & Foundation

**Status: COMPLETE**

The following foundation has been implemented:

- Technical architecture
- Flutter project scaffolding
- Feature-first folder structure
- Firebase development environment
- Firebase production environment
- Environment-based Firebase configuration
- Firebase initialization
- GetX architecture
- GetX routing foundation
- GetX dependency injection
- Navigation middleware foundation
- Professional Career SaaS design system
- Light theme
- Dark theme
- Typography system
- Spacing system
- Radius system
- Component theme foundation
- Responsive engine
- Mobile / tablet / desktop breakpoints
- Adaptive navigation foundation
- Responsive BentoGrid foundation
- Result architecture
- Error architecture
- Firebase error mapper
- SharedPreferences-based local storage service
- Connectivity service
- Environment-aware logger
- Firestore Security Rules
- Foundation verification

Current development is proceeding into:

> **Phase 1 — Authentication & Onboarding**

---

# Technology Stack

## Frontend

- Flutter
- Dart
- Material 3

## State Management

- GetX

GetX is used for:

- State management
- Routing
- Dependency injection
- Bindings
- Navigation middleware

## Authentication

- Firebase Authentication

Planned authentication methods:

- Email & Password
- Google Sign-In
- Password Reset

## Database

- Cloud Firestore

## Local Storage

- SharedPreferencesAsync

Used only for lightweight device/UI preferences.

## PDF

Planned libraries include:

- `pdf`
- `printing`

## Responsive Layout

- Custom ProPersona responsive framework
- Responsive BentoGrid abstraction
- `flutter_staggered_grid_view`

## Connectivity

- `connectivity_plus`

---

# Architecture

ProPersona follows a:

> **Feature-First Layered Architecture**

The primary architectural flow is:

```text
Presentation Layer
Views / Widgets
       ↓
GetX Controllers
       ↓
Repositories
       ↓
Firebase / Local Services / Backend APIs
```

The core development rule is:

```text
View
 ↓
Controller
 ↓
Repository
 ↓
Data Source
```

Views should **never call Firebase directly**.

---

## Responsibilities

### Views

Responsible for:

- Rendering UI
- Receiving user input
- Displaying state

Views should not contain:

- Firebase queries
- Firestore parsing
- Authentication implementation
- AI provider logic

---

### Controllers

Responsible for:

- UI state
- Loading state
- Form state
- Reactive values
- Calling repositories
- Handling `Result<T>`
- Navigation

Controllers should not contain raw Firebase implementation details.

---

### Repositories

Responsible for:

- Authentication operations
- Firestore operations
- Data transformation
- Firebase exception handling
- Returning application-safe results

Repository methods follow:

```dart
Future<Result<T>>
```

---

### Services

Responsible for infrastructure-level concerns such as:

- Local storage
- Connectivity
- Logging
- Future API clients
- Future backend integrations

---

# Project Structure

```text
lib/
│
├── main.dart
│
├── firebase_options_dev.dart
├── firebase_options_prod.dart
│
├── app/
│   │
│   ├── app.dart
│   │
│   ├── bindings/
│   │   └── initial_binding.dart
│   │
│   └── routes/
│       ├── app_pages.dart
│       ├── app_routes.dart
│       │
│       └── middleware/
│           ├── auth_middleware.dart
│           ├── onboarding_middleware.dart
│           └── subscription_middleware.dart
│
├── core/
│   │
│   ├── config/
│   │   ├── app_environment.dart
│   │   ├── environment_config.dart
│   │   └── firebase_config.dart
│   │
│   ├── constants/
│   │
│   ├── errors/
│   │   ├── app_exception.dart
│   │   ├── app_failure.dart
│   │   └── firebase_error_mapper.dart
│   │
│   ├── responsive/
│   │   ├── app_breakpoints.dart
│   │   ├── device_type.dart
│   │   ├── responsive_builder.dart
│   │   ├── responsive_extension.dart
│   │   └── responsive_value.dart
│   │
│   ├── result/
│   │   ├── result.dart
│   │   ├── success.dart
│   │   └── failure.dart
│   │
│   ├── services/
│   │   ├── connectivity_service.dart
│   │   ├── local_storage_service.dart
│   │   └── logger_service.dart
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_component_theme.dart
│   │   ├── app_radius.dart
│   │   ├── app_shadows.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart
│   │   └── app_typography.dart
│   │
│   ├── utils/
│   │
│   └── widgets/
│
├── shared/
│   │
│   ├── models/
│   │
│   └── widgets/
│       ├── app_shell.dart
│       ├── adaptive_navigation.dart
│       │
│       └── bento/
│           ├── bento_grid.dart
│           ├── bento_span.dart
│           └── bento_tile.dart
│
└── features/
    │
    ├── authentication/
    ├── onboarding/
    ├── dashboard/
    ├── resumes/
    ├── resume_builder/
    ├── ats_analyzer/
    ├── ai_tools/
    ├── cover_letter/
    ├── profile/
    ├── subscription/
    └── legal/
```

Major features follow this convention:

```text
feature/
├── bindings/
├── controllers/
├── models/
├── repositories/
├── services/
├── views/
└── widgets/
```

Not every feature must use every folder. Folders should only contain components required by that feature.

---

# Firebase Architecture

ProPersona uses separate Firebase projects for development and production.

```text
                     ProPersona
                         │
               ┌─────────┴─────────┐
               │                   │
               ▼                   ▼
          Development          Production
               │                   │
               ▼                   ▼
        Firebase DEV         Firebase PROD
```

Flutter selects the correct Firebase project through environment configuration.

Development:

```bash
flutter run --dart-define=ENV=development
```

Production:

```bash
flutter run --dart-define=ENV=production
```

Firebase configuration is resolved through:

```text
EnvironmentConfig
       ↓
FirebaseConfig
       ↓
Development / Production FirebaseOptions
```

---

## Firebase Services Used in V1

```text
Firebase Authentication    YES
Cloud Firestore            YES
Firebase Storage           NO
```

Firebase Storage is intentionally excluded from ProPersona V1.

---

# Firestore Data Model

The planned top-level collections are:

```text
users/
resumes/
resume_versions/
ats_analyses/
cover_letters/
ai_generations/
subscriptions/
```

Lightweight user-specific subcollections may include:

```text
users/{uid}/preferences/
users/{uid}/activity/
```

---

## User Profile

Conceptually:

```text
users/{uid}
```

contains information such as:

```text
uid
fullName
email
photoUrl
careerStage
onboardingCompleted
subscriptionPlan
createdAt
updatedAt
lastLoginAt
```

---

## Resume

Conceptually:

```text
resumes/{resumeId}
```

contains:

```text
id
ownerId
title
targetRole
careerStage
templateId

personalInfo
summary
education[]
experience[]
skills[]
projects[]
certifications[]
languages[]
customSections[]

atsScore
isArchived
createdAt
updatedAt
version
```

The resume architecture is intentionally hybrid:

- Core resume data stays together
- High-growth/history data is stored separately

---

## Resume Versions

```text
resume_versions/{versionId}
```

stores historical resume snapshots.

Resume versions are designed to remain immutable after creation.

---

## ATS Analyses

```text
ats_analyses/{analysisId}
```

will contain information such as:

```text
ownerId
resumeId
targetJobTitle
jobDescription

overallScore
keywordScore
experienceScore
skillsScore
formatScore

matchedKeywords[]
missingKeywords[]
strengths[]
recommendations[]

createdAt
```

ATS analysis records are intended to be **backend-authoritative**.

---

## Cover Letters

```text
cover_letters/{id}
```

will contain structured cover-letter information and generated content.

---

## AI Generation Audit

```text
ai_generations/{id}
```

will contain limited AI operation metadata such as:

```text
ownerId
taskType
provider
model
success
inputTokens
outputTokens
createdAt
```

Sensitive resume or prompt content should not be unnecessarily duplicated into audit records.

---

## Subscriptions

```text
subscriptions/{uid}
```

is intended to contain:

```text
userId
plan
status
aiRequestsUsed
aiRequestsLimit
periodStart
periodEnd
updatedAt
```

Subscription and entitlement data is server-authoritative.

---

# Security Architecture

ProPersona uses a **default-deny security model** for Firestore.

General ownership is based on:

```text
request.auth.uid == ownerId
```

Security Rules currently enforce principles including:

- Unauthenticated Firestore access is denied
- Users can access their own profile
- Users cannot enumerate user profiles
- Users can only access resumes they own
- Resume ownership cannot be reassigned
- Resume version history is immutable after creation
- Users cannot fabricate ATS analysis records
- Users cannot directly create AI audit records
- Users cannot modify subscription entitlements
- Unknown collections are denied by default

---

## Backend-Authoritative Data

Sensitive application state must not be trusted simply because it came from the Flutter client.

Examples include:

```text
ATS Scores
AI Audit Records
Subscription Plans
AI Usage Limits
Entitlements
Backend Activity Records
```

The intended flow is:

```text
Flutter Client
      ↓
Authenticated Request
      ↓
Backend
      ↓
Verify Authentication
      ↓
Validate Input
      ↓
Verify Ownership
      ↓
Verify Entitlement
      ↓
Execute Operation
      ↓
Store Authoritative Result
```

---

# Responsive Design

ProPersona uses a custom responsive system.

## Breakpoints

```text
< 600 px          Mobile
600 – 1024 px     Tablet
> 1024 px         Desktop / Web
```

---

## Adaptive Navigation

Navigation changes according to available width:

```text
Mobile
   ↓
Bottom Navigation Bar

Tablet
   ↓
Collapsed Navigation Rail

Desktop
   ↓
Extended Navigation Rail
```

---

# BentoGrid

ProPersona includes a reusable responsive BentoGrid foundation.

Baseline grid:

```text
Mobile       1 Column
Tablet       2 Columns
Desktop      4 Columns
```

Individual cards can define their own responsive span.

Example:

```dart
const BentoSpan(
  mobile: 1,
  tablet: 2,
  desktop: 2,
);
```

This allows dashboard content to reflow naturally without maintaining entirely separate screen implementations.

---

# Design System

ProPersona uses a distinct **Professional Career SaaS** product identity.

It remains a product of Huzentra Technologies while maintaining its own visual language.

---

## Primary Colors

```text
Primary Indigo      #4057D6
Primary Dark        #24348F
Secondary Blue      #4D8DFF
```

## Semantic Colors

```text
Success             #18A86B
Warning             #E5A11A
Error               #DC4C4C
Information         #3A86FF
```

## Light Theme

```text
Background          #F6F8FC
Surface             #FFFFFF
Muted Surface       #EEF2F8

Primary Text        #18202E
Secondary Text      #667085

Border              #E2E7F0
```

## Dark Theme

```text
Background          #10131A
Surface             #181D27
Muted Surface       #212735

Primary Text        #F4F7FB
Secondary Text      #A9B4C5

Border              #2B3443
```

## Typography

ProPersona uses:

> **Inter**

for its primary product interface typography.

---

# ATS Score Visual Language

ATS indicators follow a standardized semantic system:

```text
85 – 100     Excellent            Green
70 – 84      Good                 Blue
50 – 69      Needs Improvement    Amber
0 – 49       Needs Attention      Red
```

This helps maintain consistent ATS feedback throughout the application.

---

# Result & Error Handling

Repositories return:

```dart
Result<T>
```

A result is either:

```text
Success<T>
```

or:

```text
Failure<T>
```

Failures contain:

```dart
AppFailure
```

rather than exposing raw Firebase exceptions directly to presentation code.

The architecture is:

```text
Firebase / External Service
          ↓
      Repository
          ↓
     Error Mapper
          ↓
       Result<T>
      /         \
Success<T>    Failure<T>
                  ↓
             AppFailure
```

---

## Failure Categories

The application supports structured failure categories including:

```text
validation
authentication
authorization
notFound
conflict
network
timeout
rateLimited
cancelled
serviceUnavailable
firebase
unknown
```

This allows the UI to react appropriately instead of relying only on arbitrary error strings.

---

# Base Services

## LocalStorageService

Used for lightweight device preferences such as:

```text
theme_mode
last_opened_resume_id
dashboard_selected_index
onboarding_tooltips_seen
resume_builder_last_step
```

Canonical data such as resumes and subscriptions is **not stored in SharedPreferences**.

---

## ConnectivityService

Monitors available network transports and application lifecycle changes.

Connectivity state is treated as a hint:

```text
Network connection detected
      ≠
Internet guaranteed
```

Actual network operations still handle failures through the Result/Error system.

---

## LoggerService

Provides environment-aware diagnostics.

### Development

```text
Debug      Enabled
Info       Enabled
Warning    Enabled
Error      Enabled
```

### Production

```text
Debug      Disabled
Info       Disabled
Warning    Enabled
Error      Enabled
```

Detailed exceptions and stack information should not be exposed unnecessarily in production.

---

# Routing Architecture

ProPersona uses named GetX routes.

Core route structure includes:

```text
/

/login
/signup
/forgot-password

/path-selector

/dashboard

/resumes
/resumes/create
/resumes/:id/edit
/resumes/:id/preview

/ai-tools
/ai-tools/ats-analyzer
/ai-tools/bullet-polish
/ai-tools/cover-letter

/profile
/settings
/subscription

/privacy-policy
/terms-and-conditions

/not-found
```

Dynamic route helpers are used for paths such as:

```text
/resumes/{id}/edit
/resumes/{id}/preview
```

---

# Navigation Middleware

The routing foundation includes:

```text
AuthMiddleware
OnboardingMiddleware
SubscriptionMiddleware
```

The intended evaluation sequence is:

```text
Authentication
      ↓
Onboarding
      ↓
Subscription / Entitlement
```

Middleware enforcement will be connected to real application session state during the Authentication phase.

---

# File & PDF Strategy

ProPersona V1 intentionally does **not** use Firebase Storage.

Instead:

```text
Resume Information
      ↓
Cloud Firestore

Device Preferences
      ↓
SharedPreferences

Imported Files
      ↓
Temporary / Local Processing

Generated Resume
      ↓
Local PDF
      ↓
Save / Share / Print
```

---

## Why No Permanent Cloud Storage in V1?

The primary source of truth for a resume is structured data.

A PDF is considered an output representation rather than canonical resume data.

Therefore:

```text
Resume Data
    ↓
Template
    ↓
Generate PDF When Needed
```

This keeps the initial infrastructure simpler and avoids unnecessary object-storage dependencies.

A cloud object-storage provider can be introduced later if permanent file synchronization becomes necessary.

---

# Planned AI Architecture

AI capabilities will use a **protected backend architecture**.

Flutter will not directly contain AI provider API credentials.

The planned architecture is:

```text
Flutter
   ↓
Protected Backend API
   ↓
Firebase Authentication Verification
   ↓
Authorization / Entitlement Check
   ↓
AI Task
   ↓
AiProvider Abstraction
   ↓
Selected AI Provider
```

Possible provider implementations may include:

```text
Gemini
OpenAI
Future Providers
```

The Flutter application should remain independent of the underlying AI vendor.

---

## Planned AI Task Types

Examples include:

```text
resumeSummary
bulletRewrite
atsAnalysis
keywordExtraction
skillsSuggestion
coverLetter
```

Responses will use a mixture of:

- Structured fields
- Scores
- Lists
- Controlled natural-language content

The exact backend hosting solution will be finalized before the AI implementation phase.

---

# Getting Started

## Prerequisites

Install the following:

- Flutter SDK
- Dart SDK
- Git
- Firebase CLI
- FlutterFire CLI
- Android Studio and/or Visual Studio Code

Additional platform requirements may include:

### Android

- Android SDK
- Android Emulator or physical Android device

### iOS / macOS

- macOS
- Xcode

### Windows

- Visual Studio
- Desktop Development with C++ workload

---

# Clone the Repository

```bash
git clone https://github.com/hstechsolutions5-svg/ProPersona---AI-CV-Maker-App.git
```

Navigate into the repository:

```bash
cd ProPersona---AI-CV-Maker-App
```

Install Flutter dependencies:

```bash
flutter pub get
```

Verify Flutter:

```bash
flutter doctor
```

---

# Firebase Setup

ProPersona uses separate Firebase environments.

You will need appropriate Firebase projects before running Firebase-dependent functionality.

The intended environments are:

```text
Development
Production
```

Environment-specific FlutterFire configuration is used:

```text
firebase_options_dev.dart
firebase_options_prod.dart
```

If configuring a fresh Firebase environment, use the FlutterFire CLI according to your own Firebase project IDs.

Example:

```bash
flutterfire configure
```

Do not blindly point local development at the production Firebase project.

---

# Environment Configuration

The application understands:

```text
development
staging
production
```

Development and production are currently the primary configured environments.

---

## Run Development

```bash
flutter run --dart-define=ENV=development
```

## Run Web Development

```bash
flutter run -d chrome --dart-define=ENV=development
```

## Run Windows Development

```bash
flutter run -d windows --dart-define=ENV=development
```

## Run Production Configuration

```bash
flutter run --dart-define=ENV=production
```

Production should not be used for normal feature development.

---

# Firebase CLI Environment

Firebase CLI project aliases are also used independently from Flutter's `--dart-define`.

Example:

```bash
firebase use dev
```

or:

```bash
firebase use prod
```

This distinction is important:

```text
--dart-define
     ↓
Selects Firebase configuration used by Flutter

firebase use
     ↓
Selects Firebase project used by Firebase CLI commands
```

---

# Development Commands

## Install Dependencies

```bash
flutter pub get
```

## Format Dart Code

```bash
dart format lib
```

## Static Analysis

```bash
flutter analyze
```

## Run Tests

```bash
flutter test
```

## Run Development Web App

```bash
flutter run -d chrome --dart-define=ENV=development
```

## Deploy Development Firestore Rules

Ensure the development Firebase project is selected:

```bash
firebase use dev
```

Then:

```bash
firebase deploy --only firestore:rules --project dev
```

Do not deploy development changes to production unintentionally.

---

# Development Roadmap

## Phase 0 — Architecture & Foundation

**COMPLETE**

- [x] Technical Architecture
- [x] Flutter Project Scaffolding
- [x] Feature-First Architecture
- [x] Development Firebase Configuration
- [x] Production Firebase Configuration
- [x] Environment Resolver
- [x] Firebase Initialization
- [x] Design System
- [x] Light Theme
- [x] Dark Theme
- [x] Responsive Engine
- [x] Responsive Breakpoints
- [x] Adaptive Navigation Foundation
- [x] BentoGrid Foundation
- [x] GetX Routing
- [x] GetX Bindings Foundation
- [x] Routing Middleware Foundation
- [x] Result System
- [x] Error System
- [x] Firebase Error Mapping
- [x] Local Storage Service
- [x] Connectivity Service
- [x] Logger Service
- [x] Firestore Security Rules
- [x] Foundation Verification
- [x] Initial GitHub Repository Push

---

## Phase 1 — Authentication & Onboarding

**NEXT**

- [ ] User Profile Model
- [ ] Career Stage Model
- [ ] Authentication Repository
- [ ] Firebase Authentication Repository
- [ ] Profile Repository
- [ ] Authentication Controller
- [ ] Application Session State
- [ ] Email Registration
- [ ] Email Login
- [ ] Password Reset
- [ ] Google Sign-In
- [ ] Terms & Privacy Consent
- [ ] Career Path Selector
- [ ] Graduate Onboarding
- [ ] Professional Onboarding
- [ ] Firestore User Profile Creation
- [ ] Auth Middleware Integration
- [ ] Onboarding Middleware Integration
- [ ] Authentication Testing

---

## Future Phases

### Application Shell & Dashboard

- [ ] Responsive Main Shell
- [ ] Dashboard
- [ ] Quick Actions
- [ ] Recent Resume Section
- [ ] Career Stage Indicator
- [ ] ATS Overview

### Resume Management

- [ ] Resume Model
- [ ] Resume Repository
- [ ] Create Resume
- [ ] Edit Resume
- [ ] Delete Resume
- [ ] Duplicate Resume
- [ ] Archive Resume
- [ ] Resume Versioning

### Resume Builder

- [ ] Personal Information
- [ ] Professional Summary
- [ ] Education
- [ ] Experience
- [ ] Skills
- [ ] Projects
- [ ] Certifications
- [ ] Languages
- [ ] Custom Sections
- [ ] Resume Preview

### PDF Engine

- [ ] Resume Template System
- [ ] ATS-Friendly Templates
- [ ] PDF Generation
- [ ] PDF Preview
- [ ] Save
- [ ] Share
- [ ] Print

### AI Infrastructure

- [ ] Protected AI Gateway
- [ ] AI Provider Interface
- [ ] Authentication Verification
- [ ] Rate Limiting
- [ ] Entitlement Verification
- [ ] AI Error Contract
- [ ] AI Usage Tracking

### AI Tools

- [ ] Resume Summary Generator
- [ ] Bullet Point Polish
- [ ] Skills Suggestions
- [ ] Keyword Suggestions
- [ ] Resume Content Optimizer

### ATS Analyzer

- [ ] Job Description Input
- [ ] Keyword Extraction
- [ ] Resume Comparison
- [ ] ATS Score
- [ ] Matched Keywords
- [ ] Missing Keywords
- [ ] Strengths
- [ ] Recommendations

### Cover Letters

- [ ] Cover Letter Generator
- [ ] Cover Letter Editing
- [ ] Cover Letter Management
- [ ] PDF Export

### Profile & Settings

- [ ] User Profile
- [ ] Career Stage Management
- [ ] Theme Preferences
- [ ] Account Settings
- [ ] Legal Documents

### Subscription & Entitlements

- [ ] Free Plan
- [ ] Premium Plan
- [ ] AI Usage Limits
- [ ] Subscription Middleware
- [ ] Billing Provider Integration

### Release

- [ ] Automated Tests
- [ ] Integration Tests
- [ ] Performance Optimization
- [ ] Accessibility Review
- [ ] Security Review
- [ ] Beta Release
- [ ] Production Release

---

# Development Guidelines

## Architecture

Maintain:

```text
View
 ↓
Controller
 ↓
Repository
 ↓
Data Source
```

Avoid:

```text
View
 ↓
Firebase
```

---

## Firebase

Never spread raw Firebase SDK operations throughout presentation code.

Firebase implementation should remain isolated behind repositories and services.

---

## Errors

Never display:

```dart
error.toString()
```

directly to end users.

Use safe:

```dart
AppFailure.message
```

instead.

---

## Local Storage

Use SharedPreferences only for lightweight local state.

Do not use it as the canonical source for:

```text
Profiles
Resumes
ATS Analyses
Cover Letters
Subscriptions
Entitlements
```

---

## Responsive Development

Do not hardcode separate complete applications for mobile, tablet, and desktop unless absolutely necessary.

Prefer:

```text
Shared Components
       +
Responsive Layout Behavior
```

---

## Environment Safety

Do not use the production environment during routine development.

Development should normally run with:

```bash
--dart-define=ENV=development
```

---

# Security Principles

ProPersona follows these principles:

1. Never expose AI provider secrets inside Flutter.
2. Never trust user-provided ownership information without verification.
3. Keep development and production environments separate.
4. Restrict Firestore resources by authenticated ownership.
5. Keep subscription state backend-authoritative.
6. Keep ATS analysis generation backend-authoritative.
7. Keep AI usage limits backend-authoritative.
8. Do not expose raw Firebase/backend errors to users.
9. Validate privileged backend requests independently.
10. Default-deny Firestore resources that have not been explicitly authorized.

---

# Git Workflow

A feature-oriented branch workflow is recommended.

Example:

```bash
git checkout -b feature/authentication
```

Before committing:

```bash
dart format lib
flutter analyze
flutter test
```

Then:

```bash
git add .
git commit -m "feat: implement authentication foundation"
git push origin feature/authentication
```

Suggested commit prefixes:

```text
feat:      New feature
fix:       Bug fix
refactor:  Internal restructuring
docs:      Documentation
test:      Tests
chore:     Maintenance
style:     Formatting / UI styling
perf:      Performance improvements
```

---

# Contributing

ProPersona is currently in active early-stage development.

Formal public contribution guidelines may be introduced later.

For development contributions:

1. Create a focused branch.
2. Follow the existing architecture.
3. Avoid direct Firebase calls from Views.
4. Format the code.
5. Run static analysis.
6. Run relevant tests.
7. Use meaningful commits.
8. Open a Pull Request with a clear description.

---

# Repository

GitHub:

**https://github.com/hstechsolutions5-svg/ProPersona---AI-CV-Maker-App**

---

# Project Information

| Property | Details |
|---|---|
| Product | ProPersona |
| Full Name | ProPersona — The ATS Friendly CV Maker |
| Parent Organization | Huzentra Technologies |
| Lead Architect | Engr. Muhammad Huzaifa |
| Primary Framework | Flutter |
| Language | Dart |
| Architecture | Feature-First Layered Architecture |
| State Management | GetX |
| Database | Cloud Firestore |
| Authentication | Firebase Authentication |
| Cloud File Storage | Not used in V1 |
| Target Platforms | Android, iOS, Web, Windows, macOS |
| Current Stage | Phase 0 Complete |
| Next Stage | Authentication & Onboarding |
| Status | Active Development |

---

# License

A public software license has **not yet been finalized** for ProPersona.

Unless and until a license is explicitly added to this repository, the presence of source code in the repository should not be interpreted as permission for unrestricted copying, modification, redistribution, or commercial use.

All rights remain reserved by the project owner unless otherwise stated.

---

# About Huzentra Technologies

**Huzentra Technologies** is a technology startup focused on building modern, scalable, reliable, and user-focused digital solutions.

The company is currently focused on software development while growing toward broader areas including:

- Mobile applications
- Web applications
- UI/UX
- Artificial Intelligence
- Machine Learning
- Emerging technologies

### Mission

To transform ideas into reliable digital solutions through innovation, technology, and user-centered development.

### Vision

To build Huzentra Technologies into a global technology brand known for innovation, quality, and meaningful digital solutions.

### Values

```text
Innovation
Quality
Reliability
User-Centered Thinking
Continuous Learning
Integrity
Growth
```

> **Innovate. Build with Quality. Stay Reliable. Keep Learning. Grow with Integrity.**

---

# Contact

## Huzentra Technologies

**Email**  
huzentratechnologies@gmail.com

**Website**  
https://hstechsolutions5-svg.github.io/Portfolio-Website/index.html

**LinkedIn**  
https://www.linkedin.com/in/huzentra-technologies/

**Instagram**  
https://www.instagram.com/huzentratechnologies/

**Facebook**  
https://www.facebook.com/profile.php?id=61594163705896

**GitHub**  
https://github.com/hstechsolutions5-svg

**Location**  
Pakistan

---

<p align="center">
  <strong>ProPersona</strong>
</p>

<p align="center">
  <strong>The ATS Friendly CV Maker</strong>
</p>

<p align="center">
  A product by <strong>Huzentra Technologies</strong>
</p>

<p align="center">
  <em>Building Technology. Creating Possibilities.</em>
</p>
