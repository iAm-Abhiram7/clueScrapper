# 🧪 ClueScraper Testing Guide

## Overview

This guide covers all testing procedures for the ClueScraper application, including unit tests, widget tests, integration tests, and manual testing procedures.

---

## 📋 Table of Contents

1. [Test Structure](#test-structure)
2. [Running Tests](#running-tests)
3. [Unit Tests](#unit-tests)
4. [Widget Tests](#widget-tests)
5. [Integration Tests](#integration-tests)
6. [Manual Testing](#manual-testing)
7. [Test Coverage](#test-coverage)
8. [Continuous Integration](#continuous-integration)

---

## 🏗️ Test Structure

```
test/
├── unit/                          # Unit tests
│   ├── validators_test.dart       # Validation logic tests
│   ├── id_generator_test.dart     # ID generation tests
│   ├── date_formatter_test.dart   # Date formatting tests
│   └── error_handler_test.dart    # Error handling tests
├── widget/                        # Widget tests
│   ├── animated_button_test.dart
│   ├── empty_state_widget_test.dart
│   └── retry_wrapper_test.dart
└── widget_test.dart               # Default widget test

integration_test/
└── app_test.dart                  # End-to-end integration tests
```

---

## ▶️ Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/validators_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Integration Tests
```bash
flutter test integration_test/app_test.dart
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

---

## 🔬 Unit Tests

### Validators Tests (`test/unit/validators_test.dart`)

**What's Tested:**
- ✅ Email validation (valid/invalid formats)
- ✅ Password strength validation
- ✅ Confirm password matching
- ✅ Required field validation
- ✅ Message validation
- ✅ Evidence description validation

**Run:**
```bash
flutter test test/unit/validators_test.dart
```

**Expected Results:**
- All email formats validated correctly
- Password requirements enforced
- Error messages returned for invalid input

---

### ID Generator Tests (`test/unit/id_generator_test.dart`)

**What's Tested:**
- ✅ UUID v4 generation
- ✅ ID uniqueness
- ✅ ID format validation

**Run:**
```bash
flutter test test/unit/id_generator_test.dart
```

**Expected Results:**
- All generated IDs are 36 characters
- 100 consecutive IDs are all unique
- IDs contain dashes in correct positions

---

### Date Formatter Tests (`test/unit/date_formatter_test.dart`)

**What's Tested:**
- ✅ Date formatting
- ✅ Time formatting
- ✅ Relative time ("5 min ago", "2 hours ago")
- ✅ Chat timestamp formatting

**Run:**
```bash
flutter test test/unit/date_formatter_test.dart
```

**Expected Results:**
- Dates formatted as "Nov 3, 2024"
- Relative times calculated correctly
- "Just now" for timestamps < 1 minute

---

### Error Handler Tests (`test/unit/error_handler_test.dart`)

**What's Tested:**
- ✅ User-friendly error messages
- ✅ Exception type handling
- ✅ Custom exception properties

**Run:**
```bash
flutter test test/unit/error_handler_test.dart
```

**Expected Results:**
- Each exception type returns correct message
- Generic message for unknown errors
- Exception codes preserved

---

## 🎨 Widget Tests

### Animated Button Tests (`test/widget/animated_button_test.dart`)

**What's Tested:**
- ✅ Button renders child widget
- ✅ onPressed callback triggered
- ✅ Disabled state handling
- ✅ Scale animation on tap

**Run:**
```bash
flutter test test/widget/animated_button_test.dart
```

**Expected Results:**
- Button displays text correctly
- Tap calls onPressed function
- No error when onPressed is null

---

### Empty State Widget Tests (`test/widget/empty_state_widget_test.dart`)

**What's Tested:**
- ✅ Icon, title, and message display
- ✅ Action button visibility
- ✅ Action button callback
- ✅ Custom illustration support

**Run:**
```bash
flutter test test/widget/empty_state_widget_test.dart
```

**Expected Results:**
- All text elements visible
- Button shown only when action provided
- Custom illustration replaces icon

---

### Retry Wrapper Tests (`test/widget/retry_wrapper_test.dart`)

**What's Tested:**
- ✅ Child shown when no error
- ✅ Loading indicator when loading
- ✅ Error UI when error present
- ✅ Retry button functionality
- ✅ Custom error messages

**Run:**
```bash
flutter test test/widget/retry_wrapper_test.dart
```

**Expected Results:**
- Content hidden when error
- Retry button calls onRetry
- Custom messages displayed

---

## 🌐 Integration Tests

### End-to-End App Tests (`integration_test/app_test.dart`)

**What's Tested:**
- ✅ Complete signup/login flow
- ✅ New chat creation
- ✅ Navigation through all screens
- ✅ Bottom navigation functionality

**Run:**
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

Or simply:
```bash
flutter test integration_test/app_test.dart
```

**Expected Results:**
- User can sign up successfully
- User can navigate to all screens
- Chat interface accessible
- No crashes during navigation

---

## 🧑‍💻 Manual Testing

### Authentication Flow

**Test Case 1: Signup**
1. Open app
2. Tap "Sign Up"
3. Enter email: `test@example.com`
4. Enter password: `Test@1234`
5. Confirm password: `Test@1234`
6. Tap "Create Account"

**Expected:**
- ✅ Account created successfully
- ✅ Redirected to home screen
- ✅ User logged in

**Test Case 2: Login**
1. Open app
2. Enter email: `test@example.com`
3. Enter password: `Test@1234`
4. Tap "Login"

**Expected:**
- ✅ Login successful
- ✅ Redirected to home screen

**Test Case 3: Validation Errors**
1. Try signup with invalid email
2. Try short password
3. Try mismatched passwords

**Expected:**
- ✅ Error messages shown
- ✅ Form submission blocked
- ✅ Clear error descriptions

---

### Chat/Analysis Flow

**Test Case 1: Create New Chat**
1. Login
2. Tap "New Chat" button
3. Upload image from gallery
4. Type message: "What evidence do you see?"
5. Send message

**Expected:**
- ✅ Image uploads successfully
- ✅ AI responds with analysis
- ✅ Evidence detected and categorized
- ✅ Conversation saved

**Test Case 2: View Chat History**
1. Navigate to Chat History tab
2. View list of previous chats
3. Tap on a chat

**Expected:**
- ✅ All chats listed
- ✅ Most recent first
- ✅ Tapping opens chat detail

---

### Report Generation

**Test Case 1: Generate Report**
1. Open a chat with analysis
2. Tap "Generate Report" button
3. Wait for generation

**Expected:**
- ✅ Loading indicator shown
- ✅ Report generated successfully
- ✅ Success message displayed
- ✅ "View Report" button appears

**Test Case 2: View Report**
1. Generate report (Test Case 1)
2. Tap "View Report"
3. Scroll through report

**Expected:**
- ✅ Report displays correctly
- ✅ All sections present
- ✅ Evidence listed
- ✅ Timestamps correct

**Test Case 3: Share Report**
1. Open a report
2. Tap share button
3. Select sharing method

**Expected:**
- ✅ PDF generated
- ✅ Share dialog opens
- ✅ File can be shared

---

### UI/UX Testing

**Test Case 1: Animations**
1. Navigate between screens
2. Tap buttons
3. Scroll lists

**Expected:**
- ✅ Smooth page transitions
- ✅ Button press animations
- ✅ List items animate in
- ✅ No jank or stuttering

**Test Case 2: Empty States**
1. View empty chat history
2. View empty reports list

**Expected:**
- ✅ Empty state icons shown
- ✅ Helpful messages displayed
- ✅ Action buttons visible

**Test Case 3: Error States**
1. Disconnect internet
2. Try to analyze image
3. Try to login

**Expected:**
- ✅ Error messages shown
- ✅ Retry buttons appear
- ✅ User-friendly descriptions

---

### Performance Testing

**Test Case 1: Image Compression**
1. Upload large image (>5MB)
2. Observe compression

**Expected:**
- ✅ Image compressed automatically
- ✅ Upload completes quickly
- ✅ Quality acceptable

**Test Case 2: List Performance**
1. Create 50+ chats
2. Scroll chat history
3. Observe performance

**Expected:**
- ✅ Smooth scrolling
- ✅ No lag
- ✅ Fast list rendering

---

### Accessibility Testing

**Test Case 1: Screen Reader**
1. Enable TalkBack (Android) or VoiceOver (iOS)
2. Navigate through app
3. Interact with buttons

**Expected:**
- ✅ All elements have labels
- ✅ Buttons announced correctly
- ✅ Navigation works
- ✅ Error messages read aloud

**Test Case 2: Text Scaling**
1. Enable large text in device settings
2. Open app
3. Check all screens

**Expected:**
- ✅ Text scales correctly
- ✅ No text cutoff
- ✅ UI remains usable

---

## 📊 Test Coverage

### View Coverage Report

1. **Generate coverage:**
```bash
flutter test --coverage
```

2. **Generate HTML report:**
```bash
genhtml coverage/lcov.info -o coverage/html
```

3. **Open report:**
```bash
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Target Coverage

- **Overall**: 80%+
- **Core Utilities**: 90%+
- **Validators**: 95%+
- **Widgets**: 75%+

---

## 🚀 Continuous Integration

### GitHub Actions Example

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.1'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v2
      with:
        files: coverage/lcov.info
```

---

## ✅ Pre-Release Testing Checklist

- [ ] All unit tests passing
- [ ] All widget tests passing
- [ ] All integration tests passing
- [ ] Manual testing completed
- [ ] Accessibility testing completed
- [ ] Performance testing completed
- [ ] Test coverage > 80%
- [ ] No critical bugs
- [ ] No memory leaks
- [ ] Smooth animations
- [ ] Error handling tested
- [ ] Offline functionality tested
- [ ] Different screen sizes tested
- [ ] Different Android versions tested
- [ ] iOS testing completed (if applicable)

---

## 🐛 Known Issues

Document any known issues here:

1. **Issue**: Integration test may fail on first run
   - **Workaround**: Run twice
   - **Status**: Investigating

---

## 📞 Testing Support

For testing questions or issues:
- Create an issue on GitHub
- Contact the development team
- Check the testing documentation

---

**Happy Testing! 🎉**
