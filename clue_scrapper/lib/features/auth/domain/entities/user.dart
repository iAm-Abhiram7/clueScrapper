import 'package:equatable/equatable.dart';

/// User entity for domain layer
class User extends Equatable {
  final String userId;
  final String email;
  final DateTime createdAt;

  const User({
    required this.userId,
    required this.email,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [userId, email, createdAt];

  @override
  String toString() => 'User(userId: $userId, email: $email)';
}
