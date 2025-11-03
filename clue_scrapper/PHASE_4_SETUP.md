# Phase 4 - COMPLETE SETUP INSTRUCTIONS

## 🎯 What You Need To Do

### 1. **Get Your Gemini API Key**

1. Go to https://aistudio.google.com/app/apikey
2. Click "Create API Key"
3. Copy your new API key
4. Open `lib/core/constants/api_keys.dart`
5. Replace `'YOUR_GEMINI_API_KEY_HERE'` with your actual API key

Example:
```dart
static const String geminiApiKey = 'AIzaSyD...your-actual-key-here...';
```

### 2. **Add API Keys to .gitignore**

Add this line to your `.gitignore` file:
```
lib/core/constants/api_keys.dart
```

### 3. **Set Up Permissions**

#### **Android Permissions**
Edit `android/app/src/main/AndroidManifest.xml` and add before `<application>`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
```

#### **iOS Permissions**
Edit `ios/Runner/Info.plist` and add:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to analyze crime scene images</string>
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture crime scene images</string>
```

### 4. **Fix New Chat Screen**

The `new_chat_screen.dart` file needs to be recreated. Create it with this content:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../providers/chat_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  bool _isProcessing = false;

  Future<void> _pickMultipleImages() async {
    setState(() => _isProcessing = true);
    try {
      final images = await _imagePickerService.pickMultipleImages();
      if (images == null || images.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No images selected')),
          );
        }
        return;
      }
      if (mounted) await _startChat(images);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _captureImage() async {
    setState(() => _isProcessing = true);
    try {
      final image = await _imagePickerService.captureImage();
      if (image == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No photo captured')),
          );
        }
        return;
      }
      if (mounted) await _startChat([image]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _startChat(List<File> images) async {
    final chatProvider = context.read<ChatProvider>();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.userId ?? 'unknown';
    
    try {
      await chatProvider.initializeChat(images, userId);
      if (mounted && chatProvider.currentChatId != null) {
        context.go('/chat/${chatProvider.currentChatId}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(title: const Text('New Analysis')),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: appColors.indigoInk),
                  const SizedBox(height: 24),
                  Text('Processing images...', style: TextStyle(color: appColors.darkCharcoal)),
                ],
              ),
            )
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.image_search, size: 100, color: appColors.indigoInk),
                    const SizedBox(height: 32),
                    Text('Start Forensic Analysis', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 48),
                    CustomButton(
                      text: 'Select Images',
                      icon: Icons.add_photo_alternate,
                      onPressed: _pickMultipleImages,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Take Photo',
                      icon: Icons.camera_alt,
                      isOutlined: true,
                      onPressed: _captureImage,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
```

### 5. **Update main.dart**

Add ChatProvider and initialize Gemini service. Update your `main.dart`:

```dart
import '../../core/constants/api_keys.dart';
import '../../shared/services/gemini_service.dart';
import '../../shared/services/image_picker_service.dart';
import '../../features/chat/presentation/providers/chat_provider.dart';

// In main() function, after hiveService.init():
final geminiService = GeminiService(ApiKeys.geminiApiKey);
final imagePickerService = ImagePickerService();

// Then in MultiProvider, add:
ChangeNotifierProvider(
  create: (_) => ChatProvider(
    hiveService: hiveService,
    geminiService: geminiService,
    imagePickerService: imagePickerService,
  ),
),
```

### 6. **Update Router**

Add chat detail route to `lib/config/router/app_router.dart`:

```dart
import '../../features/chat/presentation/screens/chat_detail_screen.dart';

// In routes list, add:
GoRoute(
  path: '/chat/:chatId',
  name: 'chat-detail',
  builder: (context, state) {
    final chatId = state.pathParameters['chatId']!;
    return ChatDetailScreen(chatId: chatId);
  },
),
```

### 7. **Run Build Runner**

Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 8. **Test the App**

```bash
flutter run
```

## 🎯 **HOW TO TEST**

1. **Login/Signup** to the app
2. Go to **New Chat** tab (center bottom navigation)
3. Click **"Select Images"** or **"Take Photo"**
4. Select 1-10 images from your gallery
5. Wait for AI analysis (this will take a few seconds)
6. Chat screen opens automatically
7. View the AI's initial analysis
8. **Ask questions** about the images in the chat input
9. See AI responses stream in real-time
10. View **evidence cards** within AI responses

## 📱 **WHERE TO PUT YOUR API KEY**

### File: `lib/core/constants/api_keys.dart`

Replace this line:
```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

With your actual key:
```dart
static const String geminiApiKey = 'AIzaSyD_YourActualGeminiAPIKeyHere';
```

### ⚠️ **SECURITY WARNING**:
- **NEVER** commit `api_keys.dart` to Git
- Add it to `.gitignore` immediately
- For production, use environment variables or secure key management

## ✅ **Phase 4 Complete Features**

1. ✅ Image Picker Service (gallery + camera)
2. ✅ Gemini AI Integration  
3. ✅ Chat Provider (state management)
4. ✅ Chat Detail Screen
5. ✅ Message Bubbles (User + AI)
6. ✅ Evidence Cards
7. ✅ Typing Indicator
8. ✅ Chat Input Field
9. ✅ Image Gallery Header
10. ✅ Full-Screen Image Viewer
11. ✅ Streaming AI Responses
12. ✅ Auto-save to Hive
13. ✅ Evidence Extraction

## 🚀 **Next Phase**

Phase 5 will add:
- PDF Report Generation
- Report Sharing
- Export Functionality
- Professional Forensic Report Templates

---

**Questions or Issues?** Let me know and I'll help you debug!
