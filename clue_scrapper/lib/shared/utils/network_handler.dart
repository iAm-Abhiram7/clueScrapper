import '../../core/errors/app_exceptions.dart';
import '../../core/utils/app_logger.dart';

/// Network request handler with retry mechanism
class NetworkHandler {
  /// Execute a network call with automatic retry on failure
  static Future<T> handleNetworkCall<T>({
    required Future<T> Function() call,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    String? operationName,
  }) async {
    int retries = 0;
    
    while (retries < maxRetries) {
      try {
        AppLogger.network(
          'Attempt ${retries + 1}/$maxRetries',
          endpoint: operationName,
        );
        
        final result = await call();
        
        if (retries > 0) {
          AppLogger.success('Operation succeeded after ${retries + 1} attempts');
        }
        
        return result;
      } catch (e) {
        retries++;
        
        AppLogger.error(
          'Network call failed (attempt $retries/$maxRetries)',
          e,
        );
        
        if (retries >= maxRetries) {
          AppLogger.error('Max retries reached, throwing exception');
          throw NetworkException(
            'Network request failed after $maxRetries attempts',
            details: e,
          );
        }
        
        // Exponential backoff: delay increases with each retry
        final delay = retryDelay * retries;
        AppLogger.warning('Retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      }
    }
    
    throw NetworkException('Unexpected error in network handler');
  }

  /// Execute a network call with timeout
  static Future<T> withTimeout<T>({
    required Future<T> Function() call,
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    try {
      return await call().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException(
            'Operation timed out after ${timeout.inSeconds} seconds',
            details: operationName,
          );
        },
      );
    } catch (e) {
      if (e is TimeoutException) {
        rethrow;
      }
      throw NetworkException(
        'Network operation failed',
        details: e,
      );
    }
  }

  /// Combine retry and timeout
  static Future<T> handleWithRetryAndTimeout<T>({
    required Future<T> Function() call,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    return handleNetworkCall(
      call: () => withTimeout(
        call: call,
        timeout: timeout,
        operationName: operationName,
      ),
      maxRetries: maxRetries,
      retryDelay: retryDelay,
      operationName: operationName,
    );
  }
}
