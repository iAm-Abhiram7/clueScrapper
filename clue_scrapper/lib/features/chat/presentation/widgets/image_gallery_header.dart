import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Collapsible image gallery header for chat screen
class ImageGalleryHeader extends StatefulWidget {
  final List<String> imagePaths;
  final VoidCallback? onTap;

  const ImageGalleryHeader({super.key, required this.imagePaths, this.onTap});

  @override
  State<ImageGalleryHeader> createState() => _ImageGalleryHeaderState();
}

class _ImageGalleryHeaderState extends State<ImageGalleryHeader> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    if (widget.imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? 200 : 80,
      decoration: BoxDecoration(
        color: appColors.surface,
        border: Border(
          bottom: BorderSide(color: appColors.lightSage, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header with badge and expand button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.indigoInk.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image, size: 16, color: appColors.indigoInk),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.imagePaths.length} Image${widget.imagePaths.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: appColors.indigoInk,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: appColors.graphite,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          // Image thumbnails
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return _buildThumbnail(
                  widget.imagePaths[index],
                  index,
                  appColors,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String imagePath, int index, AppColors appColors) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => _showFullScreen(index),
        child: Container(
          width: _isExpanded ? 120 : 60,
          height: _isExpanded ? 120 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: appColors.lightSage, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: appColors.mutedSand.withOpacity(0.3),
                  child: Icon(Icons.broken_image, color: appColors.graphite),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreen(int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageViewer(
          imagePaths: widget.imagePaths,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

/// Full-screen image viewer with swipe navigation
class _FullScreenImageViewer extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _FullScreenImageViewer({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image viewer
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.file(
                    File(widget.imagePaths[index]),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          // Close button
          SafeArea(
            child: Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          // Image counter
          SafeArea(
            child: Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} of ${widget.imagePaths.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
