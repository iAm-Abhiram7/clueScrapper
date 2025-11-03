# 🔍 ClueScraper

**AI-Powered Forensic Analysis Mobile Application**

A Flutter-based mobile application that leverages AI to perform crime scene analysis, evidence detection, and comprehensive report generation with Visual Question Answering capabilities.

---

## ✨ Features

### 🎯 Core Functionality
- **🤖 AI-Powered Analysis**: Image-based crime scene analysis using Google's Gemini AI
- **🔍 Visual Question Answering**: Interactive Q&A about uploaded evidence images
- **📝 Evidence Categorization**: Automatic detection and classification of evidence types
- **📊 Comprehensive Reports**: Professional PDF report generation with export capabilities
- **💾 Local Storage**: Secure offline storage using Hive database
- **🔐 User Authentication**: Secure signup/login with encrypted password storage
- **📱 Cross-Platform**: Works on Android, iOS, Web, and Desktop

### 🎨 UI/UX Features
- **🇯🇵 Japanese-Inspired Design**: Minimalist Zen aesthetics
- **🎭 Smooth Animations**: Subtle transitions and micro-interactions
- **♿ Accessibility**: Screen reader support and semantic labels
- **🌓 Theme Support**: Light theme (dark theme ready for future)
- **📱 Responsive**: Adapts to different screen sizes

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: 3.8.1 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Google Gemini API Key** (for AI features)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/clue_scrapper.git
cd clue_scrapper
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up API key**
Create a `.env` file in the root directory:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

Or update `lib/core/constants/api_keys.dart`:
```dart
class ApiKeys {
  static const String geminiApiKey = 'YOUR_API_KEY_HERE';
}
```

4. **Run the app**
```bash
flutter run
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                  # App entry point with global error handling
├── config/
│   └── router/               # Navigation configuration (GoRouter)
├── core/
│   ├── constants/            # App constants and API keys
│   ├── errors/               # Error handling and custom exceptions
│   ├── theme/                # Theme configuration and colors
│   └── utils/                # Utility functions and helpers
├── features/
│   ├── auth/                 # Authentication (signup/login)
│   ├── chat/                 # Chat/Analysis interface
│   ├── home/                 # Home screen and navigation
│   ├── report/               # Report generation and viewing
│   └── settings/             # App settings
└── shared/
    ├── services/             # Shared services (Hive, Gemini, etc.)
    ├── widgets/              # Reusable widgets
    │   ├── animations/       # Animation widgets
    │   ├── common/           # Common UI components
    │   └── transitions/      # Page transitions
    └── utils/                # Shared utilities
```

---

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Widget Tests
```bash
flutter test test/widget/
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
```

---

## 📱 Supported Platforms

- ✅ **Android**: API 21+
- ✅ **iOS**: iOS 12+
- ✅ **Web**: Chrome, Firefox, Safari, Edge
- ✅ **Windows**: Windows 10+
- ✅ **macOS**: macOS 10.14+
- ✅ **Linux**: Ubuntu 18.04+

---

## 🎨 Design System

### Color Palette (Japanese-Inspired)

| Color | Hex | Usage |
|-------|-----|-------|
| **Indigo Ink** | `#3E5C76` | Primary actions, headers |
| **Warm Off-White** | `#F5F3EF` | Backgrounds, cards |
| **Light Sage** | `#B5C99A` | Success states, highlights |
| **Muted Sand** | `#E0D8C3` | Secondary elements |
| **Graphite** | `#2F2F2F` | Body text |
| **Dark Charcoal** | `#1B1B1B` | Headlines |

### Typography

- **Display**: Inter (Bold) - 32sp
- **Headline**: Inter (SemiBold) - 24sp
- **Title**: Inter (Medium) - 20sp
- **Body**: Inter (Regular) - 16sp
- **Caption**: Inter (Regular) - 14sp

---

## 📦 Key Dependencies

```yaml
# State Management
provider: ^6.1.2

# Local Storage
hive: ^2.2.3
hive_flutter: ^1.1.0
flutter_secure_storage: ^9.2.2

# AI Integration
google_generative_ai: ^0.4.3

# Image Handling
image_picker: ^1.1.2
flutter_image_compress: ^2.3.0

# PDF Generation
pdf: ^3.11.3
printing: ^5.13.2
share_plus: ^10.0.2

# Navigation
go_router: ^14.2.7
```

---

## 🔧 Configuration

### Android

Update `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.cluescraper"
    minSdkVersion 21
    targetSdkVersion 34
    versionCode 1
    versionName "1.0.0"
}
```

### iOS

Update `ios/Runner/Info.plist` for camera permissions:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture evidence images</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select evidence images</string>
```

---

## 🚀 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - *Initial work*

---

## 🙏 Acknowledgments

- Google Gemini AI for powerful AI capabilities
- Flutter team for the amazing framework
- Community contributors and testers

---

## 📞 Support

For support, email support@cluescraper.com or open an issue on GitHub.

---

## 🗺️ Roadmap

### Phase 1: Foundation ✅
- Authentication system
- Basic chat interface
- Evidence image upload

### Phase 2: AI Integration ✅
- Gemini AI integration
- Visual Question Answering
- Evidence detection

### Phase 3: Reports ✅
- Report generation
- PDF export
- Report history

### Phase 4: Advanced Features ✅
- Enhanced UI/UX
- Multiple image support
- Advanced evidence tracking

### Phase 5: Evidence System ✅
- Evidence categorization
- Evidence detail screens
- Evidence search and filter

### Phase 6: Polish & Testing ✅
- Animations and transitions
- Comprehensive testing
- Performance optimization
- Accessibility improvements

### Future Phases 🔮
- Cloud sync
- Team collaboration
- Advanced analytics
- Multi-language support

---

**Built with ❤️ using Flutter**
