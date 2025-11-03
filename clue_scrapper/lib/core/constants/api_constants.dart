/// API configuration constants
class ApiConstants {
  // Gemini AI Configuration
  static const String geminiApiKeyPlaceholder = 'YOUR_GEMINI_API_KEY';
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-1.5-pro-latest';

  // AI Parameters
  static const double temperature = 0.7;
  static const int maxTokens = 2048;
  static const double topP = 0.9;
  static const int topK = 40;

  // Prompts
  static const String forensicAnalysisSystemPrompt = '''
You are a forensic analysis AI assistant specialized in crime scene investigation.
Analyze images provided by investigators and provide detailed, professional observations.
Focus on:
1. Evidence identification and classification
2. Contextual analysis of the scene
3. Potential connections between evidence items
4. Professional forensic terminology
5. Confidence levels for observations

Always maintain objectivity and professional tone.
''';

  static const String reportGenerationPrompt = '''
Generate a comprehensive forensic analysis report based on the conversation history.
Include:
1. Executive Summary
2. Evidence Inventory
3. Detailed Observations
4. Preliminary Conclusions
5. Recommendations for further investigation

Use professional forensic report format.
''';

  // Error Messages
  static const String apiKeyMissingError = 'Gemini API key not configured';
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String timeoutError = 'Request timeout';
}
