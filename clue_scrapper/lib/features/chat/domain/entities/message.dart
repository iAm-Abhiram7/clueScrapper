import 'package:equatable/equatable.dart';

/// Message entity for domain layer
class Message extends Equatable {
  final String messageId;
  final String chatId;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? evidenceData; // JSON serialized evidence data

  const Message({
    required this.messageId,
    required this.chatId,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.evidenceData,
  });

  @override
  List<Object?> get props => [
    messageId,
    chatId,
    content,
    isUser,
    timestamp,
    evidenceData,
  ];

  Message copyWith({
    String? messageId,
    String? chatId,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? evidenceData,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      evidenceData: evidenceData ?? this.evidenceData,
    );
  }

  @override
  String toString() => 'Message(messageId: $messageId, isUser: $isUser)';
}
