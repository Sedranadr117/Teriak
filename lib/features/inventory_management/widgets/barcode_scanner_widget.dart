// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';
// import 'package:teriak/config/themes/app_icon.dart';

// class BarcodeScannerWidget extends StatefulWidget {
//   final Function(String) onBarcodeScanned;
//   final VoidCallback onClose;

//   const BarcodeScannerWidget({
//     super.key,
//     required this.onBarcodeScanned,
//     required this.onClose,
//   });

//   @override
//   State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
// }

// class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget>
//     with WidgetsBindingObserver {
//   CameraController? _cameraController;
//   List<CameraDescription> _cameras = [];
//   bool _isInitialized = false;
//   bool _isScanning = false;
//   String? _errorMessage;
//   bool _flashEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       _cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _initializeCamera();
//     }
//   }

//   Future<bool> _requestCameraPermission() async {
//     if (kIsWeb) return true;

//     final status = await Permission.camera.request();
//     return status.isGranted;
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       final hasPermission = await _requestCameraPermission();
//       if (!hasPermission) {
//         setState(() {
//           _errorMessage = 'Camera permission is required to scan barcodes';
//         });
//         return;
//       }

//       _cameras = await availableCameras();
//       if (_cameras.isEmpty) {
//         setState(() {
//           _errorMessage = 'No cameras available on this device';
//         });
//         return;
//       }

//       final camera = kIsWeb
//           ? _cameras.firstWhere(
//               (c) => c.lensDirection == CameraLensDirection.front,
//               orElse: () => _cameras.first,
//             )
//           : _cameras.firstWhere(
//               (c) => c.lensDirection == CameraLensDirection.back,
//               orElse: () => _cameras.first,
//             );

//       _cameraController = CameraController(
//         camera,
//         kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await _cameraController!.initialize();
//       await _applySettings();

//       if (mounted) {
//         setState(() {
//           _isInitialized = true;
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'Failed to initialize camera: ${e.toString()}';
//         });
//       }
//     }
//   }

//   Future<void> _applySettings() async {
//     if (_cameraController == null) return;

//     try {
//       await _cameraController!.setFocusMode(FocusMode.auto);
//       if (!kIsWeb) {
//         await _cameraController!.setFlashMode(FlashMode.off);
//       }
//     } catch (e) {
//       // Ignore settings that aren't supported
//     }
//   }

//   Future<void> _toggleFlash() async {
//     if (_cameraController == null || kIsWeb) return;

//     try {
//       final newFlashMode = _flashEnabled ? FlashMode.off : FlashMode.torch;
//       await _cameraController!.setFlashMode(newFlashMode);
//       setState(() {
//         _flashEnabled = !_flashEnabled;
//       });
//       HapticFeedback.lightImpact();
//     } catch (e) {
//       // Flash not supported
//     }
//   }

//   void _simulateBarcodeDetection() {
//     if (_isScanning) return;

//     setState(() {
//       _isScanning = true;
//     });

//     // Simulate barcode detection after a short delay
//     Future.delayed(Duration(milliseconds: 1500), () {
//       if (mounted) {
//         final mockBarcodes = [
//           '123456789012',
//           '987654321098',
//           '456789123456',
//           '789123456789',
//           '321654987321',
//         ];

//         final randomBarcode =
//             mockBarcodes[DateTime.now().millisecond % mockBarcodes.length];
//         HapticFeedback.mediumImpact();
//         widget.onBarcodeScanned(randomBarcode);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           if (_isInitialized && _cameraController != null)
//             _buildCameraPreview()
//           else if (_errorMessage != null)
//             _buildErrorView(theme, colorScheme)
//           else
//             _buildLoadingView(theme, colorScheme),
//           _buildOverlay(theme, colorScheme),
//           _buildTopControls(theme, colorScheme),
//           _buildBottomControls(theme, colorScheme),
//         ],
//       ),
//     );
//   }

//   Widget _buildCameraPreview() {
//     return SizedBox.expand(
//       child: FittedBox(
//         fit: BoxFit.cover,
//         child: SizedBox(
//           width: _cameraController!.value.previewSize!.height,
//           height: _cameraController!.value.previewSize!.width,
//           child: CameraPreview(_cameraController!),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorView(ThemeData theme, ColorScheme colorScheme) {
//     return Center(
//       child: Container(
//         margin: EdgeInsets.all(8.w),
//         padding: EdgeInsets.all(6.w),
//         decoration: BoxDecoration(
//           color: colorScheme.surface,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomIconWidget(
//               iconName: 'error_outline',
//               color: colorScheme.error,
//               size: 15.w,
//             ),
//             SizedBox(height: 2.h),
//             Text(
//               'Camera Error',
//               style: theme.textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 1.h),
//             Text(
//               _errorMessage ?? 'Unknown error occurred',
//               style: theme.textTheme.bodyMedium,
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 3.h),
//             ElevatedButton(
//               onPressed: _initializeCamera,
//               child: Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingView(ThemeData theme, ColorScheme colorScheme) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: colorScheme.surface,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 2.h),
//             Text(
//               'Initializing Camera...',
//               style: theme.textTheme.titleMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOverlay(ThemeData theme, ColorScheme colorScheme) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black.withValues(alpha: 0.5),
//       ),
//       child: Center(
//         child: Container(
//           width: 70.w,
//           height: 35.h,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: _isScanning ? colorScheme.primary : Colors.white,
//               width: 3,
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Stack(
//             children: [
//               // Corner indicators
//               Positioned(
//                 top: -3,
//                 left: -3,
//                 child: Container(
//                   width: 8.w,
//                   height: 8.w,
//                   decoration: BoxDecoration(
//                     color: _isScanning ? colorScheme.primary : Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: -3,
//                 right: -3,
//                 child: Container(
//                   width: 8.w,
//                   height: 8.w,
//                   decoration: BoxDecoration(
//                     color: _isScanning ? colorScheme.primary : Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -3,
//                 left: -3,
//                 child: Container(
//                   width: 8.w,
//                   height: 8.w,
//                   decoration: BoxDecoration(
//                     color: _isScanning ? colorScheme.primary : Colors.white,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -3,
//                 right: -3,
//                 child: Container(
//                   width: 8.w,
//                   height: 8.w,
//                   decoration: BoxDecoration(
//                     color: _isScanning ? colorScheme.primary : Colors.white,
//                     borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),

//               // Scanning animation
//               if (_isScanning)
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: colorScheme.primary.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: colorScheme.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopControls(ThemeData theme, ColorScheme colorScheme) {
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.all(4.w),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.6),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: IconButton(
//                 onPressed: widget.onClose,
//                 icon: CustomIconWidget(
//                   iconName: 'close',
//                   color: Colors.white,
//                   size: 6.w,
//                 ),
//               ),
//             ),
//             if (!kIsWeb)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withValues(alpha: 0.6),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: IconButton(
//                   onPressed: _toggleFlash,
//                   icon: CustomIconWidget(
//                     iconName: _flashEnabled ? 'flash_on' : 'flash_off',
//                     color: _flashEnabled ? colorScheme.primary : Colors.white,
//                     size: 6.w,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomControls(ThemeData theme, ColorScheme colorScheme) {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: SafeArea(
//         child: Container(
//           padding: EdgeInsets.all(6.w),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withValues(alpha: 0.8),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 _isScanning
//                     ? 'Scanning barcode...'
//                     : 'Position barcode within the frame',
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 2.h),
//               if (!_isScanning)
//                 ElevatedButton(
//                   onPressed: _simulateBarcodeDetection,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: colorScheme.primary,
//                     foregroundColor: colorScheme.onPrimary,
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomIconWidget(
//                         iconName: 'qr_code_scanner',
//                         color: colorScheme.onPrimary,
//                         size: 5.w,
//                       ),
//                       SizedBox(width: 2.w),
//                       Text('Tap to Scan'),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
