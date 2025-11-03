import 'package:equatable/equatable.dart';

/// Chat entity for domain layer
class Chat extends Equatable {
  final String chatId;
  final String userId;
  final DateTime createdAt;
  final List<String> imagePaths;
  final String status; // active, archived, deleted
  final int imageCount;

  const Chat({
    required this.chatId,
    required this.userId,
    required this.createdAt,
    required this.imagePaths,
    required this.status,
    required this.imageCount,
  });

  @override
  List<Object?> get props => [
    chatId,
    userId,
    createdAt,
    imagePaths,
    status,
    imageCount,
  ];

  Chat copyWith({
    String? chatId,
    String? userId,
    DateTime? createdAt,
    List<String>? imagePaths,
    String? status,
    int? imageCount,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      imagePaths: imagePaths ?? this.imagePaths,
      status: status ?? this.status,
      imageCount: imageCount ?? this.imageCount,
    );
  }

  @override
  String toString() =>
      'Chat(chatId: $chatId, imageCount: $imageCount, status: $status)';
}
