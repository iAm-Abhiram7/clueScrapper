# 🧪 Phase 5 Testing Guide

## Quick Start: Testing Report Generation

Follow these steps to test the complete report generation system:

### 1. Prerequisites
- ✅ All dependencies installed (`flutter pub get`)
- ✅ App running on device/emulator
- ✅ Gemini API key configured

### 2. Test Flow

#### Step 1: Create a Chat Session
1. Open the app
2. Go to "New" tab
3. Upload 2-3 crime scene images
4. Wait for initial AI analysis
5. Have a conversation (ask at least 3-4 questions about the evidence)

#### Step 2: Generate a Report
1. While in the chat, tap the **3-dot menu** (top right)
2. Select **"Generate Report"**
3. Observe:
   - Loading dialog appears
   - Progress message shows: "Generating Forensic Report..."
   - Sub-message: "Analyzing conversation history"
4. Wait 10-30 seconds (depending on conversation length)
5. Success: SnackBar appears with "Report generated successfully!"
6. Tap **"View"** in the SnackBar

#### Step 3: View Report Details
You should see:
- **Header Card** with:
  - Case ID (e.g., "Case #A1B2C3D4E5F6")
  - Generated timestamp
  - Crime Type classification
  - Evidence count
  - Images analyzed count
  - "Active Investigation" badge

- **Sections**:
  - Case Summary
  - Crime Scene Analysis
  - Evidence Catalog (with confidence meters)
  - Key Observations
  - Preliminary Findings

#### Step 4: Preview PDF
1. Tap **"Preview PDF"** button
2. PDF preview should open
3. Verify:
   - Cover page with case info
   - All sections formatted correctly
   - Evidence table
   - Page numbers
   - Professional formatting

#### Step 5: Share Report
1. Tap **"Share"** button
2. Native share sheet opens
3. Select sharing method (Email, Messages, Save to Files, etc.)
4. Verify PDF is attached

#### Step 6: View All Reports
1. Go back to Home
2. Navigate to **"Reports"** tab
3. See your generated report in the list
4. Tap the report card to open it again

#### Step 7: Search Reports
1. In Reports list, use search bar
2. Search by crime type (e.g., "homicide", "assault")
3. Search by case ID
4. Verify filtering works

#### Step 8: Delete Report
1. Open a report
2. Tap **3-dot menu** (top right)
3. Select **"Delete Report"**
4. Confirm deletion
5. Verify report is removed from list

### 3. Edge Cases to Test

#### Test Case 1: Insufficient Messages
1. Create a new chat with only 1 message
2. Try to generate report
3. **Expected**: Error message "Please have at least one conversation..."

#### Test Case 2: Regenerate Report
1. Generate a report for a chat
2. Try to generate another report for the same chat
3. **Expected**: Dialog asking "Report Exists. Do you want to regenerate?"
4. Test both "Cancel" and "Regenerate" options

#### Test Case 3: Network Error
1. Turn off internet
2. Try to generate report
3. **Expected**: Error message about network failure

#### Test Case 4: Empty Evidence
1. Chat about non-crime topics
2. Generate report
3. **Expected**: Report generated but Evidence Catalog section may be empty

### 4. Visual Verification

Check the following design elements:

#### Colors (Japanese-inspired palette)
- ✅ Primary buttons: Indigo Ink (#3E5C76)
- ✅ Borders: Light Sage (#B4C6A6)
- ✅ Text: Dark Charcoal (#1D2D44)
- ✅ Secondary text: Graphite (#748386)
- ✅ Background: Warm Off-White (#F5F3EF)

#### Evidence Cards
- ✅ Weapon: Red icon
- ✅ Biological: Purple icon
- ✅ Document: Blue icon
- ✅ Fingerprint: Orange icon

#### Confidence Meters
- ✅ 80-100%: Light Sage (green)
- ✅ 60-79%: Muted Sand (yellow)
- ✅ < 60%: Gray

### 5. Performance Checks

- ⏱️ Report generation: Should complete in < 30 seconds
- ⏱️ PDF generation: Should complete in < 5 seconds
- ⏱️ Report loading: Should be instant from cache
- 💾 PDF size: Should be < 500KB for typical reports

### 6. Expected Behavior

#### Success States
- ✅ Loading indicators during async operations
- ✅ Success messages with actionable options
- ✅ Smooth navigation between screens
- ✅ Data persists across app restarts

#### Error States
- ✅ Clear error messages
- ✅ No app crashes
- ✅ Ability to retry failed operations
- ✅ Graceful degradation

### 7. Common Issues & Solutions

#### Issue: "Report generation failed"
**Solution**: Check internet connection and Gemini API key

#### Issue: PDF preview doesn't open
**Solution**: Ensure device has PDF viewer app installed

#### Issue: Share button does nothing
**Solution**: Check app permissions for file sharing

#### Issue: Evidence catalog is empty
**Solution**: Chat needs more forensic discussion about evidence

### 8. Debug Commands

```bash
# Check logs during report generation
flutter logs | grep "GeminiService\|ReportProvider\|PdfService"

# Clear all reports (if needed for testing)
# (In Hive Box Viewer or manually delete from device)

# Rebuild app after changes
flutter clean && flutter pub get && flutter run
```

### 9. Test Data Examples

#### Good Conversation for Testing:
```
User: "What evidence can you see in the first image?"
AI: [Analyzes and identifies evidence]
User: "What about the second image?"
AI: [Analyzes second image]
User: "What's the most significant piece of evidence?"
AI: [Provides analysis]
User: "What should investigators do next?"
AI: [Provides recommendations]
```

This creates a rich conversation that will generate a comprehensive report.

### 10. Checklist

- [ ] Successfully created chat with 4+ messages
- [ ] Generated report without errors
- [ ] Viewed report detail screen
- [ ] Previewed PDF successfully
- [ ] Shared PDF via native share
- [ ] Found report in Reports list
- [ ] Searched for report successfully
- [ ] Deleted report with confirmation
- [ ] Tested "insufficient messages" error
- [ ] Tested "regenerate report" flow

## 🎉 Success Criteria

Phase 5 is working correctly if:
1. ✅ Reports generate from chat conversations
2. ✅ All report sections display correctly
3. ✅ PDFs generate and preview properly
4. ✅ Sharing works on the device
5. ✅ Reports persist and load correctly
6. ✅ Search and filter function properly
7. ✅ Error handling is graceful
8. ✅ Design matches specifications

---

**Happy Testing! 🧪🔬**

If you encounter any issues, check the error logs or refer to PHASE_5_COMPLETE.md for implementation details.
