# ClueScraper - AI-Powered Forensic Analysis

## Overview
ClueScraper is a mobile forensic analysis application powered by AI Visual Question Answering capabilities. Built with Flutter and integrated with Google's Gemini AI, it enables investigators to analyze crime scene images and generate professional forensic reports.

## Architecture

This project follows **Clean Architecture** principles with a **feature-first** folder structure:

```
lib/
├── core/                   # Core functionality shared across features
│   ├── constants/          # Application constants
│   ├── theme/              # Theme and styling
│   ├── utils/              # Utility functions
│   └── errors/             # Error handling
│
├── shared/                 # Shared widgets and services
│   ├── widgets/            # Reusable UI components
│   └── services/           # Shared services (Hive, etc.)
│
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer (models, datasources, repositories)
│   │   ├── domain/         # Domain layer (entities, repositories, use cases)
│   │   └── presentation/   # Presentation layer (providers, screens, widgets)
│   ├── chat/               # Chat/Analysis feature (Phase 2)
│   ├── report/             # Report generation feature (Phase 3)
│   └── home/               # Home screen
│
├── config/                 # App configuration
│   └── router/             # Navigation/routing
│
└── main.dart               # App entry point
```

### Clean Architecture Layers

1. **Domain Layer** (Business Logic)
   - Entities: Core business objects
   - Repositories: Abstract interfaces
   - Use Cases: Business logic operations

2. **Data Layer** (Data Management)
   - Models: Data transfer objects with Hive annotations
   - Data Sources: Local storage implementations
   - Repository Implementations: Concrete repository classes

3. **Presentation Layer** (UI)
   - Providers: State management (using Provider package)
   - Screens: UI screens
   - Widgets: UI components

## Technology Stack

- **Framework**: Flutter 3.24.0+
- **Language**: Dart 3.5+
- **State Management**: Provider
- **Local Database**: Hive (NoSQL)
- **Navigation**: GoRouter
- **AI Integration**: Google Generative AI (Gemini)
- **Security**: Flutter Secure Storage

## Phase 1 Implementation ✅

### Completed Features

1. **Project Setup**
   - Clean architecture folder structure
   - Dependency injection setup
   - Theme configuration with Japanese-inspired design

2. **Theme & Design**
   - Custom color palette (Graphite, Warm Off-White, Indigo Ink, Light Sage, Muted Sand)
   - Minimalist UI inspired by Zen gardens and Japanese architecture
   - Material Design 3 implementation
   - Custom text styles and component themes

3. **Data Models**
   - User (TypeId: 0)
   - Chat (TypeId: 1)
   - Message (TypeId: 2)
   - Evidence (TypeId: 3)
   - Report (TypeId: 4)

4. **Core Services**
   - HiveService: Local database management
   - AuthLocalDataSource: Authentication operations
   - Validators: Input validation utilities
   - DateFormatter: Date/time formatting
   - IdGenerator: UUID generation

5. **Authentication**
   - Login screen
   - Signup screen
   - Password hashing (SHA-256)
   - Session management
   - Route guards

6. **Navigation**
   - GoRouter configuration
   - Authentication-based routing
   - Splash screen
   - Home screen with bottom navigation

## Getting Started

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart 3.5 or higher
- Android Studio / VS Code with Flutter plugins

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### First Run

1. The app will show a splash screen
2. Navigate to the signup screen
3. Create an account with:
   - Valid email format
   - Password with at least 8 characters, including uppercase, lowercase, number, and special character
4. After signup, you'll be logged in automatically

## Data Storage

All data is stored locally using Hive:

- **User data**: Encrypted passwords, user profiles
- **Chat data**: Analysis sessions, image paths
- **Message data**: Conversation history
- **Evidence data**: Identified evidence items
- **Report data**: Generated forensic reports

Sensitive data (auth tokens, API keys) is stored in Flutter Secure Storage.

## Future Phases

### Phase 2: Chat & AI Integration
- Image upload functionality
- AI-powered image analysis using Gemini
- Chat interface for Q&A
- Evidence tagging and classification

### Phase 3: Report Generation
- Automated report creation
- PDF export
- Evidence summary
- Professional forensic formatting

### Phase 4: Advanced Features
- Multi-image analysis
- Evidence correlation
- Advanced search and filtering
- Cloud backup (optional)

## Code Style

- Follow Dart style guidelines
- Use meaningful variable and function names
- Add comprehensive comments
- Use null safety throughout
- Implement error handling

## Development Commands

```bash
# Get dependencies
flutter pub get

# Generate code (Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter pub run build_runner watch

# Run the app
flutter run

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

## Project Structure Highlights

### Constants
- `AppConstants`: App-wide configuration
- `ApiConstants`: AI service configuration
- `StorageKeys`: Hive box and key names

### Utilities
- `Validators`: Email, password, form validation
- `DateFormatter`: Date/time formatting utilities
- `IdGenerator`: UUID generation for entities

### Exceptions
- `AuthException`: Authentication errors
- `StorageException`: Database errors
- `NetworkException`: Network errors
- `AIException`: AI service errors

## Contributing

This is Phase 1 of the project. Future phases will build upon this foundation to add AI analysis and report generation capabilities.

## License

Private project - All rights reserved

---

**ClueScraper v1.0.0 - Phase 1 Complete** ✅
