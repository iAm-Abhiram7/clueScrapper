import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User model with Hive annotations for local storage
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String passwordHash;

  @HiveField(3)
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
  });

  /// Convert to domain entity
  User toEntity() {
    return User(userId: userId, email: email, createdAt: createdAt);
  }

  /// Create from domain entity
  factory UserModel.fromEntity(User user, String passwordHash) {
    return UserModel(
      userId: user.userId,
      email: user.email,
      passwordHash: passwordHash,
      createdAt: user.createdAt,
    );
  }

  /// Create a copy with modified fields
  UserModel copyWith({
    String? userId,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'UserModel(userId: $userId, email: $email)';
}
