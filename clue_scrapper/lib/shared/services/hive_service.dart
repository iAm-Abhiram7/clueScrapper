import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/errors/exceptions.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/chat/data/models/chat_model.dart';
import '../../features/chat/data/models/message_model.dart';
import '../../features/chat/data/models/evidence_model.dart';
import '../../features/report/data/models/report_model.dart';

/// Service for managing Hive local database
/// Handles initialization, registration of adapters, and box management
class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  bool _isInitialized = false;

  /// Initialize Hive and register all type adapters
  Future<void> init() async {
    if (_isInitialized) {
      debugPrint('HiveService: Already initialized');
      return;
    }

    try {
      // Initialize Hive for Flutter
      await Hive.initFlutter();
      debugPrint('HiveService: Hive initialized');

      // Register all type adapters
      _registerAdapters();

      // Open all required boxes
      await _openBoxes();

      _isInitialized = true;
      debugPrint('HiveService: Initialization complete');
    } catch (e, stackTrace) {
      debugPrint('HiveService: Initialization failed - $e');
      debugPrint('StackTrace: $stackTrace');
      throw StorageException(
        'Failed to initialize Hive database',
        details: e.toString(),
      );
    }
  }

  /// Register all Hive type adapters
  void _registerAdapters() {
    try {
      // Check if adapters are already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
        debugPrint('HiveService: UserModel adapter registered (TypeId: 0)');
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ChatModelAdapter());
        debugPrint('HiveService: ChatModel adapter registered (TypeId: 1)');
      }

      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(MessageModelAdapter());
        debugPrint('HiveService: MessageModel adapter registered (TypeId: 2)');
      }

      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(EvidenceModelAdapter());
        debugPrint('HiveService: EvidenceModel adapter registered (TypeId: 3)');
      }

      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(ReportModelAdapter());
        debugPrint('HiveService: ReportModel adapter registered (TypeId: 4)');
      }
    } catch (e) {
      debugPrint('HiveService: Adapter registration failed - $e');
      throw StorageException(
        'Failed to register type adapters',
        details: e.toString(),
      );
    }
  }

  /// Open all required Hive boxes
  Future<void> _openBoxes() async {
    try {
      await Future.wait([
        _openBox<UserModel>(StorageKeys.userBox),
        _openBox<ChatModel>(StorageKeys.chatBox),
        _openBox<MessageModel>(StorageKeys.messageBox),
        _openBox<EvidenceModel>(StorageKeys.evidenceBox),
        _openBox<ReportModel>(StorageKeys.reportBox),
      ]);
      debugPrint('HiveService: All boxes opened successfully');
    } catch (e) {
      debugPrint('HiveService: Failed to open boxes - $e');
      throw StorageException(
        'Failed to open storage boxes',
        details: e.toString(),
      );
    }
  }

  /// Open a specific Hive box
  Future<Box<T>> _openBox<T>(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        debugPrint('HiveService: Box "$boxName" already open');
        return Hive.box<T>(boxName);
      }

      final box = await Hive.openBox<T>(boxName);
      debugPrint('HiveService: Opened box "$boxName"');
      return box;
    } catch (e) {
      debugPrint('HiveService: Failed to open box "$boxName" - $e');
      rethrow;
    }
  }

  /// Get a box by name
  Box<T> getBox<T>(String boxName) {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        throw StorageException('Box "$boxName" is not open');
      }
      return Hive.box<T>(boxName);
    } catch (e) {
      throw StorageException(
        'Failed to get box "$boxName"',
        details: e.toString(),
      );
    }
  }

  /// Get user box
  Box<UserModel> get userBox => getBox<UserModel>(StorageKeys.userBox);

  /// Get chat box
  Box<ChatModel> get chatBox => getBox<ChatModel>(StorageKeys.chatBox);

  /// Get message box
  Box<MessageModel> get messageBox =>
      getBox<MessageModel>(StorageKeys.messageBox);

  /// Get evidence box
  Box<EvidenceModel> get evidenceBox =>
      getBox<EvidenceModel>(StorageKeys.evidenceBox);

  /// Get report box
  Box<ReportModel> get reportBox => getBox<ReportModel>(StorageKeys.reportBox);

  /// Clear all data (useful for logout or data reset)
  Future<void> clearAllData() async {
    try {
      await Future.wait([
        userBox.clear(),
        chatBox.clear(),
        messageBox.clear(),
        evidenceBox.clear(),
        reportBox.clear(),
      ]);
      debugPrint('HiveService: All data cleared');
    } catch (e) {
      throw StorageException('Failed to clear data', details: e.toString());
    }
  }

  /// Clear specific box
  Future<void> clearBox(String boxName) async {
    try {
      final box = getBox(boxName);
      await box.clear();
      debugPrint('HiveService: Cleared box "$boxName"');
    } catch (e) {
      throw StorageException(
        'Failed to clear box "$boxName"',
        details: e.toString(),
      );
    }
  }

  /// Close all boxes
  Future<void> closeAllBoxes() async {
    try {
      await Hive.close();
      _isInitialized = false;
      debugPrint('HiveService: All boxes closed');
    } catch (e) {
      throw StorageException('Failed to close boxes', details: e.toString());
    }
  }

  /// Delete specific box (removes from disk)
  Future<void> deleteBox(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      debugPrint('HiveService: Deleted box "$boxName" from disk');
    } catch (e) {
      throw StorageException(
        'Failed to delete box "$boxName"',
        details: e.toString(),
      );
    }
  }

  /// Compact all boxes (reduces file size)
  Future<void> compactAllBoxes() async {
    try {
      await Future.wait([
        userBox.compact(),
        chatBox.compact(),
        messageBox.compact(),
        evidenceBox.compact(),
        reportBox.compact(),
      ]);
      debugPrint('HiveService: All boxes compacted');
    } catch (e) {
      throw StorageException('Failed to compact boxes', details: e.toString());
    }
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}
