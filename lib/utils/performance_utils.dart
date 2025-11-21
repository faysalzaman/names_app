// Performance utilities for the Names App
import 'package:flutter/material.dart';

class PerformanceUtils {
  // Optimized image cache configuration
  static void configureImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50 MB
  }

  // Debounce utility for search
  static void debounce(
    Function() action, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Future.delayed(delay, action);
  }
}

// Optimized cached image widget
class OptimizedImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const OptimizedImage({
    Key? key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: width != null 
          ? (width! * MediaQuery.of(context).devicePixelRatio).round()
          : null,
      cacheHeight: height != null
          ? (height! * MediaQuery.of(context).devicePixelRatio).round()
          : null,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.red),
        );
      },
    );
  }
}

// Optimized list item widget
class OptimizedListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const OptimizedListItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListTile(
        title: Text(
          title,
          style: textStyle,
        ),
        onTap: onTap,
      ),
    );
  }
}
