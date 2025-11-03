import 'package:hive/hive.dart';
import '../../domain/entities/message.dart';

part 'message_model.g.dart';

/// Message model with Hive annotations for local storage
@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String messageId;

  @HiveField(1)
  final String chatId;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final bool isUser;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String? evidenceData;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.evidenceData,
  });

  /// Convert to domain entity
  Message toEntity() {
    return Message(
      messageId: messageId,
      chatId: chatId,
      content: content,
      isUser: isUser,
      timestamp: timestamp,
      evidenceData: evidenceData,
    );
  }

  /// Create from domain entity
  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      messageId: message.messageId,
      chatId: message.chatId,
      content: message.content,
      isUser: message.isUser,
      timestamp: message.timestamp,
      evidenceData: message.evidenceData,
    );
  }

  /// Create a copy with modified fields
  MessageModel copyWith({
    String? messageId,
    String? chatId,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? evidenceData,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      evidenceData: evidenceData ?? this.evidenceData,
    );
  }

  @override
  String toString() => 'MessageModel(messageId: $messageId, isUser: $isUser)';
}
