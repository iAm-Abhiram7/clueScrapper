import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/utils/app_logger.dart';

/// Image optimization utilities for performance
class ImageOptimizer {
  /// Compress a single image file
  /// Returns compressed file or original if compression fails
  static Future<File> compressImage(
    File file, {
    int quality = 85,
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    try {
      AppLogger.info('Compressing image: ${file.path}');

      final String targetPath = file.path.replaceAll(
        '.${file.path.split('.').last}',
        '_compressed.${file.path.split('.').last}',
      );

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      if (result != null) {
        final compressed = File(result.path);
        final originalSize = await file.length();
        final compressedSize = await compressed.length();
        final reduction = ((1 - (compressedSize / originalSize)) * 100).toStringAsFixed(1);

        AppLogger.success(
          'Image compressed: ${originalSize ~/ 1024}KB → ${compressedSize ~/ 1024}KB ($reduction% reduction)',
        );

        return compressed;
      }

      AppLogger.warning('Compression returned null, using original file');
      return file;
    } catch (e) {
      AppLogger.error('Image compression failed', e);
      return file;
    }
  }

  /// Compress multiple images in parallel
  static Future<List<File>> compressMultiple(
    List<File> files, {
    int quality = 85,
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    AppLogger.info('Compressing ${files.length} images...');

    final futures = files.map(
      (file) => compressImage(
        file,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      ),
    );

    final results = await Future.wait(futures);
    AppLogger.success('Compressed ${results.length} images');

    return results;
  }

  /// Get optimized quality based on file size
  static int getOptimalQuality(int fileSizeBytes) {
    const int mb = 1024 * 1024;

    if (fileSizeBytes < mb) {
      return 90; // Small file, keep high quality
    } else if (fileSizeBytes < 3 * mb) {
      return 85; // Medium file, good quality
    } else if (fileSizeBytes < 5 * mb) {
      return 75; // Large file, reduce quality
    } else {
      return 65; // Very large file, aggressive compression
    }
  }

  /// Compress with automatic quality adjustment
  static Future<File> compressWithAutoQuality(File file) async {
    final fileSize = await file.length();
    final quality = getOptimalQuality(fileSize);

    AppLogger.info('Auto quality: $quality for ${fileSize ~/ 1024}KB file');

    return compressImage(file, quality: quality);
  }
}
