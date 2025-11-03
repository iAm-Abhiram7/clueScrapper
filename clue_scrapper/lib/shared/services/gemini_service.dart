import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../features/chat/domain/entities/evidence.dart';
import '../../features/chat/domain/entities/message.dart';

/// Service for interacting with Google Gemini AI
///
/// Provides forensic analysis capabilities using Gemini Vision models
/// for crime scene image analysis and Visual Question Answering
class GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _visionModel;
  final String _apiKey;

  // Forensic analysis system prompt
  static const String forensicAnalysisPrompt = '''
You are a forensic analysis AI assistant specializing in crime scene investigation. Analyze the provided crime scene images with professional forensic expertise.

For each image, identify and categorize evidence:

1. **WEAPONS**: Firearms, knives, tools, or objects used in the crime
2. **BIOLOGICAL**: Blood, bodily fluids, tissues, hair samples, DNA evidence
3. **DOCUMENTS**: Papers, notes, IDs, receipts, written evidence
4. **FINGERPRINTS**: Visible prints on surfaces, smudges, or marks

Provide structured responses in this format for each piece of evidence:

EVIDENCE_START
TYPE: [WEAPON/BIOLOGICAL/DOCUMENT/FINGERPRINT]
DESCRIPTION: [Detailed forensic description]
CONFIDENCE: [Percentage as integer, e.g., 85]
LOCATION: [Where in the image]
EVIDENCE_END

After analyzing all evidence, provide:
- Overall crime scene assessment
- Key observations
- Recommended forensic procedures
- Potential evidence relationships

Be precise, professional, and detailed in your analysis.
''';

  GeminiService(this._apiKey) {
    _initializeModels();
  }

  /// Initialize Gemini models
  void _initializeModels() {
    try {
      final safetySettings = [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ];

      // Text-only model for chat
      _model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: _apiKey,
        safetySettings: safetySettings,
      );

      // Vision model for image analysis
      _visionModel = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        safetySettings: safetySettings,
      );

      debugPrint('GeminiService: Models initialized successfully');
      debugPrint('GeminiService: Text model: gemini-1.5-pro-latest');
      debugPrint('GeminiService: Vision model: gemini-1.5-flash-latest');
    } catch (e) {
      debugPrint('GeminiService: Error initializing models - $e');
      rethrow;
    }
  }

  /// Analyze images with initial forensic analysis
  ///
  /// [images] List of image files to analyze
  /// [prompt] Optional custom prompt, defaults to forensic analysis
  ///
  /// Returns AI response text
  Future<String> analyzeImages(List<File> images, {String? prompt}) async {
    try {
      debugPrint('GeminiService: Analyzing ${images.length} images');

      // Prepare image data
      final imageParts = <DataPart>[];
      for (final image in images) {
        final bytes = await image.readAsBytes();
        imageParts.add(DataPart('image/jpeg', bytes));
      }

      // Create content with system prompt and images
      final content = Content.multi([
        TextPart(prompt ?? forensicAnalysisPrompt),
        ...imageParts,
      ]);

      // Generate response
      final response = await _visionModel.generateContent([content]);

      final responseText = response.text ?? '';
      debugPrint(
        'GeminiService: Analysis complete - ${responseText.length} characters',
      );

      return responseText;
    } catch (e) {
      debugPrint('GeminiService: Error analyzing images - $e');
      throw GeminiException('Failed to analyze images: $e');
    }
  }

  /// Ask a question about images with chat context
  ///
  /// [question] User's question
  /// [images] List of image files
  /// [chatHistory] Previous messages for context
  ///
  /// Returns AI response text
  Future<String> askQuestion(
    String question,
    List<File> images, {
    List<Message>? chatHistory,
  }) async {
    try {
      debugPrint('GeminiService: Processing question - $question');

      // Build conversation history
      final contents = <Content>[];

      // Add chat history if available
      if (chatHistory != null && chatHistory.isNotEmpty) {
        for (final message in chatHistory.take(10)) {
          // Last 10 messages for context
          contents.add(
            Content.text(
              message.isUser
                  ? 'User: ${message.content}'
                  : 'Assistant: ${message.content}',
            ),
          );
        }
      }

      // Prepare image data
      final imageParts = <DataPart>[];
      for (final image in images) {
        final bytes = await image.readAsBytes();
        imageParts.add(DataPart('image/jpeg', bytes));
      }

      // Add current question with images
      contents.add(Content.multi([TextPart(question), ...imageParts]));

      // Generate response
      final response = await _visionModel.generateContent(contents);

      final responseText = response.text ?? '';
      debugPrint(
        'GeminiService: Question answered - ${responseText.length} characters',
      );

      return responseText;
    } catch (e) {
      debugPrint('GeminiService: Error asking question - $e');
      throw GeminiException('Failed to process question: $e');
    }
  }

  /// Ask question with streaming response
  ///
  /// [question] User's question
  /// [images] List of image files
  /// [chatHistory] Previous messages for context
  ///
  /// Yields chunks of response text as they arrive
  Stream<String> askQuestionStream(
    String question,
    List<File> images, {
    List<Message>? chatHistory,
  }) async* {
    try {
      debugPrint('GeminiService: Streaming question - $question');

      // Build conversation history
      final contents = <Content>[];

      // Add chat history if available
      if (chatHistory != null && chatHistory.isNotEmpty) {
        for (final message in chatHistory.take(10)) {
          contents.add(
            Content.text(
              message.isUser
                  ? 'User: ${message.content}'
                  : 'Assistant: ${message.content}',
            ),
          );
        }
      }

      // Prepare image data
      final imageParts = <DataPart>[];
      for (final image in images) {
        final bytes = await image.readAsBytes();
        imageParts.add(DataPart('image/jpeg', bytes));
      }

      // Add current question with images
      contents.add(Content.multi([TextPart(question), ...imageParts]));

      // Generate streaming response
      final response = _visionModel.generateContentStream(contents);

      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }

      debugPrint('GeminiService: Streaming complete');
    } catch (e) {
      debugPrint('GeminiService: Error in streaming - $e');
      throw GeminiException('Failed to stream response: $e');
    }
  }

  /// Extract evidence from AI response text
  ///
  /// Parses structured evidence markers in the format:
  /// EVIDENCE_START
  /// TYPE: WEAPON
  /// DESCRIPTION: ...
  /// CONFIDENCE: 85
  /// LOCATION: ...
  /// EVIDENCE_END
  ///
  /// Returns list of Evidence objects
  List<Evidence> extractEvidence(String aiResponse) {
    final evidenceList = <Evidence>[];

    try {
      // Find all evidence blocks
      final evidencePattern = RegExp(
        r'EVIDENCE_START\s*'
        r'TYPE:\s*(\w+)\s*'
        r'DESCRIPTION:\s*([^\n]+)\s*'
        r'CONFIDENCE:\s*(\d+)\s*'
        r'LOCATION:\s*([^\n]+)\s*'
        r'EVIDENCE_END',
        multiLine: true,
        caseSensitive: false,
      );

      final matches = evidencePattern.allMatches(aiResponse);

      for (final match in matches) {
        final type = match.group(1)?.trim().toUpperCase() ?? 'UNKNOWN';
        final description = match.group(2)?.trim() ?? '';
        final confidenceStr = match.group(3)?.trim() ?? '0';
        final location = match.group(4)?.trim() ?? '';

        // Parse confidence as double (0.0 to 1.0)
        final confidenceInt = int.tryParse(confidenceStr) ?? 0;
        final confidence =
            confidenceInt / 100.0; // Convert percentage to decimal

        // Create Evidence object
        final evidence = Evidence(
          evidenceId: DateTime.now().millisecondsSinceEpoch.toString(),
          type: type.toLowerCase(),
          description: '$description (Location: $location)',
          confidence: confidence,
          imageReference: '', // Will be set by caller if needed
        );

        evidenceList.add(evidence);
      }

      debugPrint(
        'GeminiService: Extracted ${evidenceList.length} evidence items',
      );
    } catch (e) {
      debugPrint('GeminiService: Error extracting evidence - $e');
    }

    return evidenceList;
  }

  /// Generate evidence summary for report
  ///
  /// [messages] All messages in the chat
  ///
  /// Returns formatted summary text
  Future<String> generateEvidenceSummary(List<Message> messages) async {
    try {
      // Collect all AI responses
      final aiResponses = messages
          .where((m) => !m.isUser)
          .map((m) => m.content)
          .join('\n\n');

      // Create summary prompt
      final summaryPrompt =
          '''
Based on the following forensic analysis conversation, generate a comprehensive evidence summary report:

$aiResponses

Provide a structured summary including:
1. Total evidence items identified
2. Breakdown by category (Weapons, Biological, Documents, Fingerprints)
3. High-confidence findings (>80%)
4. Key observations and conclusions
5. Recommended next steps for investigation

Format the response in a professional forensic report style.
''';

      final content = Content.text(summaryPrompt);
      final response = await _model.generateContent([content]);

      return response.text ?? 'Unable to generate summary';
    } catch (e) {
      debugPrint('GeminiService: Error generating summary - $e');
      throw GeminiException('Failed to generate evidence summary: $e');
    }
  }
}

/// Custom exception for Gemini service errors
class GeminiException implements Exception {
  final String message;

  GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
