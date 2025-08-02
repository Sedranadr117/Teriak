import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_assets.dart';
import 'package:teriak/config/themes/app_icon.dart';

class PhotoCaptureWidget extends StatelessWidget {
  final String? initialImagePath;
  final Function(String?) onImageCaptured;

  const PhotoCaptureWidget({
    super.key,
    this.initialImagePath,
    required this.onImageCaptured,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showImageOptions(context),
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(15.w),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.w),
                child: initialImagePath != null
                    ? Image.asset(Assets.assetsImagesJustLogo)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'camera_alt',
                              color: colorScheme.primary.withValues(alpha: 0.6),
                              size: 10.w,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Add Photo',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Customer Photo (Optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          if (initialImagePath != null) ...[
            SizedBox(height: 1.h),
            TextButton(
              onPressed: () => onImageCaptured(null),
              child: Text(
                'Remove Photo',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _captureFromCamera(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _selectFromGallery(context);
              },
            ),
            if (initialImagePath != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: Theme.of(context).colorScheme.error,
                  size: 6.w,
                ),
                title: Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  onImageCaptured(null);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _captureFromCamera(BuildContext context) {
    // Simulate camera capture
    // In a real app, you would use image_picker package
    final simulatedImageUrl =
        'https://images.unsplash.com/photo-1494790108755-2616b612b1c5?w=300&h=300&fit=crop&crop=face';
    onImageCaptured(simulatedImageUrl);
  }

  void _selectFromGallery(BuildContext context) {
    // Simulate gallery selection
    // In a real app, you would use image_picker package
    final simulatedImageUrl =
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face';
    onImageCaptured(simulatedImageUrl);
  }
}
