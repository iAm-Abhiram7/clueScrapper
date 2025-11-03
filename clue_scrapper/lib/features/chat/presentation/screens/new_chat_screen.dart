import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';

/// Screen for starting a new chat with image selection
class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  List<File> _selectedImages = [];
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        title: const Text('New Analysis'),
        backgroundColor: appColors.background,
        elevation: 0,
      ),
      body: _isProcessing
          ? _buildProcessingView(appColors)
          : _selectedImages.isEmpty
          ? _buildEmptyState(appColors)
          : _buildImagePreview(appColors),
    );
  }

  /// Build empty state with image selection options
  Widget _buildEmptyState(AppColors appColors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: appColors.lightSage.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 60,
                color: appColors.indigoInk,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Start Forensic Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appColors.darkCharcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Select crime scene images to begin AI-powered analysis',
              style: TextStyle(fontSize: 16, color: appColors.graphite),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Select Images Button
            CustomButton(
              text: 'Select Images from Gallery',
              onPressed: _pickImagesFromGallery,
              icon: Icons.photo_library,
            ),
            const SizedBox(height: 16),

            // Take Photo Button
            CustomButton(
              text: 'Take Photo',
              onPressed: _captureImageWithCamera,
              icon: Icons.camera_alt,
              isOutlined: true,
            ),
            const SizedBox(height: 24),

            // Info text
            Text(
              'Maximum 10 images • JPG, PNG, HEIC',
              style: TextStyle(
                fontSize: 14,
                color: appColors.graphite.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build image preview screen
  Widget _buildImagePreview(AppColors appColors) {
    return Column(
      children: [
        // Image count header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.photo_library, color: appColors.indigoInk, size: 20),
              const SizedBox(width: 8),
              Text(
                '${_selectedImages.length} ${_selectedImages.length == 1 ? 'Image' : 'Images'} Selected',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: appColors.darkCharcoal,
                ),
              ),
              const Spacer(),
              if (_selectedImages.length < ImagePickerService.maxImages)
                TextButton.icon(
                  onPressed: _pickImagesFromGallery,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add More'),
                ),
            ],
          ),
        ),

        // Image grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _selectedImages.length,
            itemBuilder: (context, index) {
              return _buildImageThumbnail(
                _selectedImages[index],
                index,
                appColors,
              );
            },
          ),
        ),

        // Bottom actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: appColors.lightSage, width: 1),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  text: 'Start Analysis',
                  onPressed: _startAnalysis,
                  icon: Icons.auto_awesome,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _clearImages,
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: appColors.graphite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build individual image thumbnail
  Widget _buildImageThumbnail(File image, int index, AppColors appColors) {
    return Stack(
      children: [
        // Image
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: appColors.lightSage, width: 2),
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
        ),

        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: appColors.graphite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  /// Build processing/loading view
  Widget _buildProcessingView(AppColors appColors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
          const SizedBox(height: 24),
          Text(
            'Processing Images...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: appColors.darkCharcoal,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'AI is analyzing your crime scene images',
            style: TextStyle(fontSize: 14, color: appColors.graphite),
          ),
        ],
      ),
    );
  }

  /// Pick images from gallery
  Future<void> _pickImagesFromGallery() async {
    try {
      final imagePickerService = context.read<ImagePickerService>();
      final images = await imagePickerService.pickMultipleImages();

      if (images != null && images.isNotEmpty) {
        setState(() {
          // Add new images, but respect the limit
          final remainingSlots =
              ImagePickerService.maxImages - _selectedImages.length;
          final imagesToAdd = images.take(remainingSlots).toList();
          _selectedImages.addAll(imagesToAdd);
        });

        if (images.length >
            ImagePickerService.maxImages -
                (_selectedImages.length - images.length)) {
          _showSnackBar(
            'Maximum ${ImagePickerService.maxImages} images allowed. Extra images were not added.',
          );
        }
      }
    } catch (e) {
      _showSnackBar('Failed to pick images: $e');
    }
  }

  /// Capture image with camera
  Future<void> _captureImageWithCamera() async {
    try {
      if (_selectedImages.length >= ImagePickerService.maxImages) {
        _showSnackBar('Maximum ${ImagePickerService.maxImages} images allowed');
        return;
      }

      final imagePickerService = context.read<ImagePickerService>();
      final image = await imagePickerService.captureImage();

      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      _showSnackBar('Failed to capture image: $e');
    }
  }

  /// Remove image from selection
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  /// Clear all images
  void _clearImages() {
    setState(() {
      _selectedImages.clear();
    });
  }

  /// Start analysis and navigate to chat
  Future<void> _startAnalysis() async {
    if (_selectedImages.isEmpty) {
      _showSnackBar('Please select at least one image');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final chatProvider = context.read<ChatProvider>();
      final currentUser = authProvider.currentUser;

      if (currentUser == null) {
        _showSnackBar('Please log in to continue');
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // Initialize chat with images
      await chatProvider.initializeChat(_selectedImages, currentUser.userId);

      // Navigate to chat detail screen
      if (mounted && chatProvider.currentChatId != null) {
        context.go('/chat/${chatProvider.currentChatId}');
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showSnackBar('Failed to start analysis: $e');
    }
  }

  /// Show snackbar message
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }
  }
}
