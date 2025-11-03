import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../shared/services/hive_service.dart';
import '../../../../shared/services/gemini_service.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/evidence.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/evidence_model.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing chat state and AI interactions
///
/// Handles:
/// - Chat creation and management
/// - Message sending and receiving
/// - AI integration with Gemini
/// - Evidence extraction and storage
/// - Image management
class ChatProvider extends ChangeNotifier {
  final HiveService _hiveService;
  final GeminiService _geminiService;
  final ImagePickerService _imagePickerService;

  // State
  String? _currentChatId;
  List<Message> _messages = [];
  List<String> _imagePaths = [];
  List<Evidence> _evidenceList = [];
  bool _isLoading = false;
  String? _error;
  String _streamingResponse = '';

  final Uuid _uuid = const Uuid();

  ChatProvider({
    required HiveService hiveService,
    required GeminiService geminiService,
    required ImagePickerService imagePickerService,
  }) : _hiveService = hiveService,
       _geminiService = geminiService,
       _imagePickerService = imagePickerService;

  // Getters
  String? get currentChatId => _currentChatId;
  List<Message> get messages => List.unmodifiable(_messages);
  List<String> get imagePaths => List.unmodifiable(_imagePaths);
  List<Evidence> get evidenceList => List.unmodifiable(_evidenceList);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get streamingResponse => _streamingResponse;
  bool get hasImages => _imagePaths.isNotEmpty;

  /// Initialize a new chat session
  ///
  /// [images] List of image files to analyze
  /// [userId] Current user ID
  Future<void> initializeChat(List<File> images, String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Generate chat ID
      _currentChatId = _uuid.v4().substring(0, 6).toUpperCase();

      // Save images to storage
      _imagePaths.clear();
      for (final image in images) {
        final savedPath = await _imagePickerService.saveImage(
          image,
          _currentChatId!,
        );
        _imagePaths.add(savedPath);
      }

      // Create chat object
      final chat = ChatModel(
        chatId: _currentChatId!,
        userId: userId,
        createdAt: DateTime.now(),
        imagePaths: _imagePaths,
        imageCount: _imagePaths.length,
        status: 'active',
      );

      // Save to Hive
      final chatBox = _hiveService.chatBox;
      await chatBox.put(_currentChatId, chat);

      // Perform initial AI analysis
      await _performInitialAnalysis(images);

      _isLoading = false;
      notifyListeners();

      debugPrint('ChatProvider: Chat initialized - $_currentChatId');
    } catch (e) {
      _error = 'Failed to initialize chat: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('ChatProvider: Error initializing chat - $e');
    }
  }

  /// Perform initial forensic analysis of images
  Future<void> _performInitialAnalysis(List<File> images) async {
    try {
      // Send initial analysis message
      final initialMessage = MessageModel(
        messageId: _uuid.v4(),
        chatId: _currentChatId!,
        content:
            'Analyzing ${images.length} crime scene image${images.length > 1 ? 's' : ''}...',
        isUser: true,
        timestamp: DateTime.now(),
      );

      await _saveMessage(initialMessage);
      _messages.add(initialMessage.toEntity());
      notifyListeners();

      // Get AI analysis
      final response = await _geminiService.analyzeImages(images);

      // Create AI response message
      final aiMessage = MessageModel(
        messageId: _uuid.v4(),
        chatId: _currentChatId!,
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      await _saveMessage(aiMessage);
      _messages.add(aiMessage.toEntity());

      // Extract evidence
      final evidence = _geminiService.extractEvidence(response);
      if (evidence.isNotEmpty) {
        await _saveEvidence(evidence);
        _evidenceList.addAll(evidence);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('ChatProvider: Error in initial analysis - $e');
      _error = 'Analysis failed: $e';
      notifyListeners();
    }
  }

  /// Send a message and get AI response
  ///
  /// [content] User's message/question
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _currentChatId == null) return;

    try {
      _error = null;

      // Create user message
      final userMessage = MessageModel(
        messageId: _uuid.v4(),
        chatId: _currentChatId!,
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      );

      await _saveMessage(userMessage);
      _messages.add(userMessage.toEntity());
      notifyListeners();

      // Load images for AI context
      final images = await _loadImages();

      // Get AI response with streaming
      await _getAIResponseStreaming(content, images);
    } catch (e) {
      _error = 'Failed to send message: $e';
      notifyListeners();
      debugPrint('ChatProvider: Error sending message - $e');
    }
  }

  /// Get AI response with streaming
  Future<void> _getAIResponseStreaming(
    String question,
    List<File> images,
  ) async {
    try {
      _isLoading = true;
      _streamingResponse = '';
      notifyListeners();

      // Create placeholder message for streaming
      final aiMessageId = _uuid.v4();

      // Stream response
      await for (final chunk in _geminiService.askQuestionStream(
        question,
        images,
        chatHistory: _messages,
      )) {
        _streamingResponse += chunk;
        notifyListeners();
      }

      // Save complete response
      final aiMessage = MessageModel(
        messageId: aiMessageId,
        chatId: _currentChatId!,
        content: _streamingResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      await _saveMessage(aiMessage);
      _messages.add(aiMessage.toEntity());

      // Extract and save evidence
      final evidence = _geminiService.extractEvidence(_streamingResponse);
      if (evidence.isNotEmpty) {
        await _saveEvidence(evidence);
        _evidenceList.addAll(evidence);
      }

      _streamingResponse = '';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'AI response failed: $e';
      _isLoading = false;
      _streamingResponse = '';
      notifyListeners();
      debugPrint('ChatProvider: Error getting AI response - $e');
    }
  }

  /// Load existing chat
  ///
  /// [chatId] ID of chat to load
  Future<void> loadChat(String chatId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentChatId = chatId;

      // Load chat data
      final chatBox = _hiveService.chatBox;
      final chat = chatBox.get(chatId);

      if (chat == null) {
        throw Exception('Chat not found');
      }

      _imagePaths = List.from(chat.imagePaths);

      // Load messages
      await _loadMessages();

      // Load evidence
      await _loadEvidence();

      _isLoading = false;
      notifyListeners();

      debugPrint('ChatProvider: Chat loaded - $chatId');
    } catch (e) {
      _error = 'Failed to load chat: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('ChatProvider: Error loading chat - $e');
    }
  }

  /// Load messages for current chat
  Future<void> _loadMessages() async {
    try {
      final messageBox = _hiveService.messageBox;

      final chatMessages = messageBox.values
          .where((msg) => msg.chatId == _currentChatId)
          .toList();

      chatMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      _messages = chatMessages.map((m) => m.toEntity()).toList();

      debugPrint('ChatProvider: Loaded ${_messages.length} messages');
    } catch (e) {
      debugPrint('ChatProvider: Error loading messages - $e');
    }
  }

  /// Load evidence for current chat
  Future<void> _loadEvidence() async {
    try {
      final evidenceBox = _hiveService.evidenceBox;

      final chatEvidence = evidenceBox.values
          .where((ev) => _messages.any((msg) => msg.messageId == ev.evidenceId))
          .toList();

      _evidenceList = chatEvidence.map((e) => e.toEntity()).toList();

      debugPrint('ChatProvider: Loaded ${_evidenceList.length} evidence items');
    } catch (e) {
      debugPrint('ChatProvider: Error loading evidence - $e');
    }
  }

  /// Save message to Hive
  Future<void> _saveMessage(MessageModel message) async {
    try {
      final messageBox = _hiveService.messageBox;
      await messageBox.put(message.messageId, message);

      // Update chat metadata
      await _updateChatMetadata();

      debugPrint('ChatProvider: Message saved - ${message.messageId}');
    } catch (e) {
      debugPrint('ChatProvider: Error saving message - $e');
    }
  }

  /// Save evidence to Hive
  Future<void> _saveEvidence(List<Evidence> evidenceList) async {
    try {
      final evidenceBox = _hiveService.evidenceBox;

      for (final evidence in evidenceList) {
        final model = EvidenceModel.fromEntity(evidence);
        await evidenceBox.put(evidence.evidenceId, model);
      }

      // Update chat metadata
      await _updateChatMetadata();

      debugPrint('ChatProvider: Saved ${evidenceList.length} evidence items');
    } catch (e) {
      debugPrint('ChatProvider: Error saving evidence - $e');
    }
  }

  /// Update chat metadata (message count, evidence count, etc.)
  Future<void> _updateChatMetadata() async {
    try {
      final chatBox = _hiveService.chatBox;
      final chat = chatBox.get(_currentChatId);

      if (chat != null) {
        final updatedChat = chat.copyWith(imageCount: _imagePaths.length);

        await chatBox.put(_currentChatId, updatedChat);
      }
    } catch (e) {
      debugPrint('ChatProvider: Error updating chat metadata - $e');
    }
  }

  /// Load image files from paths
  Future<List<File>> _loadImages() async {
    final images = <File>[];

    for (final path in _imagePaths) {
      final image = await _imagePickerService.loadImage(path);
      if (image != null) {
        images.add(image);
      }
    }

    return images;
  }

  /// Clear current chat and reset state
  void clearChat() {
    _currentChatId = null;
    _messages.clear();
    _imagePaths.clear();
    _evidenceList.clear();
    _error = null;
    _isLoading = false;
    _streamingResponse = '';
    notifyListeners();
  }

  /// Delete a chat and all its data
  Future<void> deleteChat(String chatId) async {
    try {
      // Delete messages
      final messageBox = _hiveService.messageBox;
      final messagesToDelete = messageBox.values
          .where((msg) => msg.chatId == chatId)
          .map((msg) => msg.messageId)
          .toList();

      for (final msgId in messagesToDelete) {
        await messageBox.delete(msgId);
      }

      // Delete evidence
      final evidenceBox = _hiveService.evidenceBox;
      final evidenceToDelete = evidenceBox.values
          .where((ev) => messagesToDelete.contains(ev.evidenceId))
          .map((ev) => ev.evidenceId)
          .toList();

      for (final evId in evidenceToDelete) {
        await evidenceBox.delete(evId);
      }

      // Delete images
      await _imagePickerService.deleteChatImages(chatId);

      // Delete chat
      final chatBox = _hiveService.chatBox;
      await chatBox.delete(chatId);

      debugPrint('ChatProvider: Chat deleted - $chatId');

      // Clear if this was the current chat
      if (_currentChatId == chatId) {
        clearChat();
      }
    } catch (e) {
      debugPrint('ChatProvider: Error deleting chat - $e');
      rethrow;
    }
  }
}
