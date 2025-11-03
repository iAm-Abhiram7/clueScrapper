# Phase 4 Implementation - Image Picker & Chat Interface

## ✅ Completed Components

### 1. Image Picker Service
**File**: `lib/shared/services/image_picker_service.dart`

**Features Implemented**:
- ✅ Pick multiple images from gallery (max 10)
- ✅ Pick single image from gallery
- ✅ Capture photo with camera
- ✅ Image validation (format, size, existence)
- ✅ Image compression (quality 85%, max 1920x1080)
- ✅ Image storage management (save, load, delete)
- ✅ Chat-specific image organization
- ✅ File size checking (max 10MB)
- ✅ Supported formats: JPG, PNG, HEIC

**Configuration**:
- Max images per session: 10
- Max file size: 10MB
- Image quality: 85%
- Max dimensions: 1920x1080px

### 2. Gemini AI Service
**File**: `lib/shared/services/gemini_service.dart`

**Features Implemented**:
- ✅ Gemini Pro model for text chat
- ✅ Gemini 1.5 Flash (Vision) for image analysis
- ✅ Forensic analysis system prompt
- ✅ Multi-image analysis capability
- ✅ Visual Question Answering (VQA)
- ✅ Streaming responses for real-time feedback
- ✅ Evidence extraction with regex parsing
- ✅ Evidence summary generation for reports
- ✅ Chat history context management
- ✅ Safety settings configured
- ✅ Custom exception handling

**Evidence Detection**:
Parses AI responses for structured evidence markers:
```
EVIDENCE_START
TYPE: [WEAPON/BIOLOGICAL/DOCUMENT/FINGERPRINT]
DESCRIPTION: [Details]
CONFIDENCE: [0-100]
LOCATION: [Where in image]
EVIDENCE_END
```

### 3. Chat Provider
**File**: `lib/features/chat/presentation/providers/chat_provider.dart`

**State Management**:
- ✅ Current chat ID tracking
- ✅ Messages list management
- ✅ Image paths storage
- ✅ Evidence list management
- ✅ Loading states
- ✅ Error handling
- ✅ Streaming response buffer

**Methods Implemented**:
- ✅ `initializeChat()` - Start new chat with images
- ✅ `sendMessage()` - Send user message and get AI response
- ✅ `loadChat()` - Load existing chat from Hive
- ✅ `clearChat()` - Reset chat state
- ✅ `deleteChat()` - Delete chat and all associated data
- ✅ `_performInitialAnalysis()` - Initial AI analysis of images
- ✅ `_getAIResponseStreaming()` - Get streaming AI responses
- ✅ `_saveMessage()` - Persist message to Hive
- ✅ `_saveEvidence()` - Persist evidence to Hive
- ✅ `_loadMessages()` - Load messages from Hive
- ✅ `_loadEvidence()` - Load evidence from Hive
- ✅ `_updateChatMetadata()` - Update chat statistics
- ✅ `_loadImages()` - Load image files from paths

**Auto-save Features**:
- Messages saved immediately to Hive
- Evidence extracted and stored automatically
- Chat metadata updated after each operation
- Image paths stored with chat

### 4. Dependencies Added
**Updated**: `pubspec.yaml`

New dependencies:
```yaml
flutter_image_compress: ^2.3.0  # Image compression
```

Existing dependencies used:
- `image_picker: ^1.1.2` - Image selection
- `google_generative_ai: ^0.4.6` - Gemini AI
- `path_provider: ^2.1.3` - File storage
- `uuid: ^4.4.0` - ID generation

## 📋 TODO - Remaining Phase 4 Work

### 1. Image Selection & Preview Screen
**File to create**: `lib/features/chat/presentation/screens/image_selection_screen.dart`

Need to implement:
- [ ] Image selection UI after picker returns images
- [ ] Horizontal scrollable carousel of selected images
- [ ] Image preview cards (120x120dp)
- [ ] Remove button for each image
- [ ] "Add More Images" button (respecting max 10 limit)
- [ ] "Continue to Chat" button
- [ ] Image count indicator
- [ ] Navigation to chat screen with images

### 2. Chat Detail Screen
**File to create**: `lib/features/chat/presentation/screens/chat_detail_screen.dart`

Need to implement:
- [ ] AppBar with case ID and status
- [ ] Image gallery header (collapsible)
- [ ] Messages list with ListView.builder
- [ ] User message bubbles (right-aligned, Indigo Ink)
- [ ] AI message bubbles (left-aligned, white with border)
- [ ] Evidence cards within AI messages
- [ ] Typing indicator for AI processing
- [ ] Chat input field at bottom
- [ ] Send button with enable/disable logic
- [ ] Keyboard handling and scroll behavior
- [ ] Auto-scroll to bottom on new messages

### 3. Message Bubble Widgets
**Files to create**:
- `lib/features/chat/presentation/widgets/user_message_bubble.dart`
- `lib/features/chat/presentation/widgets/ai_message_bubble.dart`
- `lib/features/chat/presentation/widgets/evidence_card.dart`
- `lib/features/chat/presentation/widgets/typing_indicator.dart`

Components needed:
- [ ] User message bubble with timestamp
- [ ] AI message bubble with avatar
- [ ] Evidence card with icon, type, confidence
- [ ] Confidence progress indicator
- [ ] Animated typing indicator (3 dots)

### 4. Image Gallery Components
**Files to create**:
- `lib/features/chat/presentation/widgets/image_gallery_header.dart`
- `lib/features/chat/presentation/widgets/full_screen_image_viewer.dart`

Components needed:
- [ ] Collapsible image gallery (80px/200px height)
- [ ] Horizontal scrollable thumbnails
- [ ] Image count badge
- [ ] Tap to expand/collapse animation
- [ ] Full-screen viewer with Hero animation
- [ ] Pinch to zoom functionality
- [ ] Swipe between images
- [ ] Image counter (1 of 3)

### 5. Chat Input Widget
**File to create**: `lib/features/chat/presentation/widgets/chat_input_field.dart`

Components needed:
- [ ] Auto-expanding TextField (max 5 lines)
- [ ] Send button (enabled/disabled states)
- [ ] Keyboard dismiss on send
- [ ] Focus management
- [ ] Character limit (optional)

### 6. Update New Chat Screen
**File to update**: `lib/features/chat/presentation/screens/new_chat_screen.dart`

Need to add:
- [ ] Image picker integration
- [ ] Loading indicator while processing
- [ ] Error handling for picker failures
- [ ] Permission request dialogs
- [ ] Navigation to image selection or chat screen

### 7. Router Updates
**File to update**: `lib/config/router/app_router.dart`

Need to add routes:
- [ ] `/chat/:chatId` - Chat detail screen
- [ ] `/chat/new/select-images` - Image selection screen
- [ ] Deep linking support for chat sessions

### 8. Main.dart Updates
**File to update**: `lib/main.dart`

Need to add:
- [ ] ChatProvider to MultiProvider
- [ ] Initialize Gemini Service with API key
- [ ] Initialize ImagePickerService
- [ ] Pass services to ChatProvider

### 9. Permission Setup

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to analyze crime scene images</string>
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture crime scene images</string>
```

### 10. API Key Configuration

Need to create: `lib/core/constants/api_keys.dart` (add to .gitignore)
```dart
class ApiKeys {
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
}
```

Or use environment variables for production.

## 🎨 Design Specifications

### Message Bubbles

**User Messages**:
- Background: Indigo Ink (#3E5C76)
- Text: White
- Max width: 75% screen
- Border radius: 16px-16px-4px-16px
- Padding: 12px horizontal, 10px vertical
- Margin: 8px bottom
- Align: Right

**AI Messages**:
- Background: White
- Text: Dark Charcoal (#1B1B1B)
- Border: 1px Light Sage (#B5C99A)
- Max width: 80% screen
- Border radius: 4px-16px-16px-16px
- Padding: 12px horizontal, 10px vertical
- Margin: 8px bottom
- Align: Left

**Evidence Cards** (within AI messages):
- Background: Light Sage @ 10% opacity
- Border-left: 4px Indigo Ink
- Padding: 12px
- Border radius: 8px
- Icon: 20x20dp emoji/icon
- Confidence bar: Linear progress indicator

### Image Gallery
- Collapsed height: 80px
- Expanded height: 200px
- Thumbnail size: 60x60dp
- Border: 2px Light Sage
- Spacing: 8px between images
- Background: White with bottom border

### Chat Input
- Min height: 48px (single line)
- Max lines: 5
- Background: White
- Top border: 1px Light Sage
- Padding: 12px
- Send button: 40x40dp circle, Indigo Ink

## 🔧 Implementation Priority

1. **HIGH PRIORITY** (MVP):
   - [ ] Chat detail screen basic layout
   - [ ] Message bubbles (user & AI)
   - [ ] Chat input field with send
   - [ ] Image gallery header (collapsed view)
   - [ ] Update new chat screen with image picker
   - [ ] Router configuration
   - [ ] Provider setup in main.dart

2. **MEDIUM PRIORITY**:
   - [ ] Evidence cards display
   - [ ] Typing indicator animation
   - [ ] Full-screen image viewer
   - [ ] Streaming response UI
   - [ ] Error states and retry

3. **LOW PRIORITY** (Polish):
   - [ ] Image gallery expand/collapse animation
   - [ ] Pinch to zoom
   - [ ] Message entrance animations
   - [ ] Confidence bar animations
   - [ ] Haptic feedback

## 📝 Next Steps

1. **Install new dependency**:
   ```bash
   flutter pub get
   ```

2. **Add permissions** to Android and iOS manifests

3. **Create API key configuration** (don't commit to Git!)

4. **Implement chat detail screen** with basic message list

5. **Create message bubble widgets**

6. **Add chat input field**

7. **Update new chat screen** to use image picker service

8. **Configure router** for chat navigation

9. **Update main.dart** with ChatProvider and services

10. **Test end-to-end flow**: Pick images → Analyze → Chat → View evidence

## ⚠️ Important Notes

- **API Key Security**: Never commit Gemini API key to repository
- **Image Storage**: Images stored in app documents directory, organized by chat ID
- **Streaming**: AI responses stream in real-time for better UX
- **Auto-save**: All messages and evidence auto-saved to Hive
- **Error Handling**: Comprehensive try-catch blocks for all async operations
- **Memory Management**: Dispose controllers, clear image cache, cancel streams

## 🚀 Ready for Phase 5

Once Phase 4 is complete with chat interface working:
- Phase 5: Report Generation (PDF export, sharing)
- Phase 6: Advanced Features (archive, search, filters)
- Phase 7: Settings & Profile
- Phase 8: Polish & Testing

---

**Status**: Core services implemented ✅  
**Next**: Build UI screens and integrate services
