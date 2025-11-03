import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Service for handling image selection and management
///
/// Provides methods for:
/// - Picking multiple images from gallery
/// - Capturing photos with camera
/// - Image validation and compression
/// - Image storage management
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Configuration constants
  static const int maxImages = 10;
  static const int maxFileSizeInMB = 10;
  static const int maxFileSizeInBytes = maxFileSizeInMB * 1024 * 1024;
  static const int imageQuality = 85;
  static const int maxWidth = 1920;
  static const int maxHeight = 1080;
  static const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'heic'];

  /// Pick multiple images from gallery
  ///
  /// Returns list of validated and compressed image files
  /// Maximum [maxImages] images allowed
  Future<List<File>?> pickMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (pickedFiles == null || pickedFiles.isEmpty) {
        return null;
      }

      // Limit to max images
      final limitedFiles = pickedFiles.take(maxImages).toList();

      // Validate and compress each image
      final List<File> validatedImages = [];
      for (final pickedFile in limitedFiles) {
        final file = File(pickedFile.path);

        if (await _validateImage(file)) {
          final compressedFile = await _compressImage(file);
          validatedImages.add(compressedFile);
        } else {
          debugPrint(
            'ImagePickerService: Invalid image skipped - ${pickedFile.path}',
          );
        }
      }

      return validatedImages.isEmpty ? null : validatedImages;
    } catch (e) {
      debugPrint('ImagePickerService: Error picking multiple images - $e');
      return null;
    }
  }

  /// Pick a single image from gallery
  ///
  /// Returns validated and compressed image file
  Future<File?> pickSingleImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (pickedFile == null) {
        return null;
      }

      final file = File(pickedFile.path);

      if (!await _validateImage(file)) {
        debugPrint('ImagePickerService: Invalid image - ${pickedFile.path}');
        return null;
      }

      return await _compressImage(file);
    } catch (e) {
      debugPrint('ImagePickerService: Error picking single image - $e');
      return null;
    }
  }

  /// Capture an image using the camera
  ///
  /// Returns validated and compressed image file
  Future<File?> captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (pickedFile == null) {
        return null;
      }

      final file = File(pickedFile.path);

      if (!await _validateImage(file)) {
        debugPrint(
          'ImagePickerService: Invalid captured image - ${pickedFile.path}',
        );
        return null;
      }

      return await _compressImage(file);
    } catch (e) {
      debugPrint('ImagePickerService: Error capturing image - $e');
      return null;
    }
  }

  /// Validate image file
  ///
  /// Checks:
  /// - File exists
  /// - File size within limit
  /// - File format is supported
  Future<bool> _validateImage(File image) async {
    try {
      // Check if file exists
      if (!await image.exists()) {
        debugPrint('ImagePickerService: Image file does not exist');
        return false;
      }

      // Check file size
      final fileSize = await image.length();
      if (fileSize > maxFileSizeInBytes) {
        debugPrint(
          'ImagePickerService: Image too large - ${fileSize / (1024 * 1024)} MB',
        );
        return false;
      }

      // Check file format
      final extension = image.path.split('.').last.toLowerCase();
      if (!supportedFormats.contains(extension)) {
        debugPrint('ImagePickerService: Unsupported format - $extension');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('ImagePickerService: Error validating image - $e');
      return false;
    }
  }

  /// Compress image to reduce file size
  ///
  /// Returns compressed image file
  Future<File> _compressImage(File image) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/${_uuid.v4()}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        quality: imageQuality,
        minWidth: maxWidth,
        minHeight: maxHeight,
      );

      if (compressedFile == null) {
        debugPrint('ImagePickerService: Compression failed, using original');
        return image;
      }

      return File(compressedFile.path);
    } catch (e) {
      debugPrint(
        'ImagePickerService: Error compressing image - $e, using original',
      );
      return image;
    }
  }

  /// Save image to app's documents directory
  ///
  /// [image] Image file to save
  /// [chatId] Chat ID for organizing images
  ///
  /// Returns path to saved image
  Future<String> saveImage(File image, String chatId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${appDir.path}/chats/$chatId');

      // Create chat directory if it doesn't exist
      if (!await chatDir.exists()) {
        await chatDir.create(recursive: true);
      }

      // Generate unique filename
      final fileName = '${_uuid.v4()}.jpg';
      final targetPath = '${chatDir.path}/$fileName';

      // Copy image to target path
      final savedImage = await image.copy(targetPath);

      debugPrint('ImagePickerService: Image saved to $targetPath');
      return savedImage.path;
    } catch (e) {
      debugPrint('ImagePickerService: Error saving image - $e');
      rethrow;
    }
  }

  /// Load image from path
  ///
  /// [path] Path to the image file
  ///
  /// Returns File object if exists, null otherwise
  Future<File?> loadImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return file;
      }
      debugPrint('ImagePickerService: Image not found at $path');
      return null;
    } catch (e) {
      debugPrint('ImagePickerService: Error loading image - $e');
      return null;
    }
  }

  /// Delete image file
  ///
  /// [path] Path to the image file
  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('ImagePickerService: Image deleted from $path');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('ImagePickerService: Error deleting image - $e');
      return false;
    }
  }

  /// Delete all images for a chat
  ///
  /// [chatId] Chat ID whose images to delete
  Future<void> deleteChatImages(String chatId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${appDir.path}/chats/$chatId');

      if (await chatDir.exists()) {
        await chatDir.delete(recursive: true);
        debugPrint('ImagePickerService: Deleted all images for chat $chatId');
      }
    } catch (e) {
      debugPrint('ImagePickerService: Error deleting chat images - $e');
    }
  }

  /// Get file size in MB
  ///
  /// [file] File to check size
  Future<double> getFileSizeInMB(File file) async {
    try {
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      debugPrint('ImagePickerService: Error getting file size - $e');
      return 0;
    }
  }
}
