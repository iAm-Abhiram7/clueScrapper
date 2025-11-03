import 'package:flutter/material.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/theme/app_colors.dart';

/// Retry wrapper widget for error states
/// Shows error UI with retry button
class RetryWrapper extends StatelessWidget {
  final Future<void> Function() onRetry;
  final Widget child;
  final Object? error;
  final bool isLoading;
  final String? customMessage;

  const RetryWrapper({
    super.key,
    required this.onRetry,
    required this.child,
    this.error,
    this.isLoading = false,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light();
      final errorMessage = customMessage ?? ErrorHandler.getUserFriendlyMessage(error!);

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: colors.mutedSand,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.graphite,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.indigoInk,
                  foregroundColor: colors.warmOffWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
