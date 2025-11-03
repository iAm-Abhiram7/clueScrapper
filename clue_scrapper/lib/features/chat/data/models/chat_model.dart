import 'package:hive/hive.dart';
import '../../domain/entities/chat.dart';

part 'chat_model.g.dart';

/// Chat model with Hive annotations for local storage
@HiveType(typeId: 1)
class ChatModel extends HiveObject {
  @HiveField(0)
  final String chatId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final List<String> imagePaths;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final int imageCount;

  ChatModel({
    required this.chatId,
    required this.userId,
    required this.createdAt,
    required this.imagePaths,
    required this.status,
    required this.imageCount,
  });

  /// Convert to domain entity
  Chat toEntity() {
    return Chat(
      chatId: chatId,
      userId: userId,
      createdAt: createdAt,
      imagePaths: List<String>.from(imagePaths),
      status: status,
      imageCount: imageCount,
    );
  }

  /// Create from domain entity
  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      chatId: chat.chatId,
      userId: chat.userId,
      createdAt: chat.createdAt,
      imagePaths: List<String>.from(chat.imagePaths),
      status: chat.status,
      imageCount: chat.imageCount,
    );
  }

  /// Create a copy with modified fields
  ChatModel copyWith({
    String? chatId,
    String? userId,
    DateTime? createdAt,
    List<String>? imagePaths,
    String? status,
    int? imageCount,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      imagePaths: imagePaths ?? this.imagePaths,
      status: status ?? this.status,
      imageCount: imageCount ?? this.imageCount,
    );
  }

  @override
  String toString() => 'ChatModel(chatId: $chatId, imageCount: $imageCount)';
}
