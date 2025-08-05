// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';

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

// class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
//   CameraController? _cameraController;
//   List<CameraDescription> _cameras = [];
//   bool _isInitialized = false;
//   bool _isScanning = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       // Request camera permission
//       if (!await _requestCameraPermission()) {
//         setState(() {
//           _errorMessage = 'Camera permission is required to scan barcodes';
//         });
//         return;
//       }

//       // Get available cameras
//       _cameras = await availableCameras();
//       if (_cameras.isEmpty) {
//         setState(() {
//           _errorMessage = 'No cameras available on this device';
//         });
//         return;
//       }

//       // Select appropriate camera
//       final camera = kIsWeb
//           ? _cameras.firstWhere(
//               (c) => c.lensDirection == CameraLensDirection.front,
//               orElse: () => _cameras.first,
//             )
//           : _cameras.firstWhere(
//               (c) => c.lensDirection == CameraLensDirection.back,
//               orElse: () => _cameras.first,
//             );

//       // Initialize camera controller
//       _cameraController = CameraController(
//         camera,
//         kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
//       );

//       await _cameraController!.initialize();

//       // Apply camera settings (skip unsupported features on web)
//       await _applyCameraSettings();

//       setState(() {
//         _isInitialized = true;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to initialize camera: ${e.toString()}';
//       });
//     }
//   }

//   Future<bool> _requestCameraPermission() async {
//     if (kIsWeb) return true; // Browser handles permissions

//     final status = await Permission.camera.request();
//     return status.isGranted;
//   }

//   Future<void> _applyCameraSettings() async {
//     if (_cameraController == null) return;

//     try {
//       await _cameraController!.setFocusMode(FocusMode.auto);

//       // Skip flash settings on web as they're not supported
//       if (!kIsWeb) {
//         try {
//           await _cameraController!.setFlashMode(FlashMode.auto);
//         } catch (e) {
//           // Flash not supported, continue without it
//         }
//       }
//     } catch (e) {
//       // Settings not supported, continue without them
//     }
//   }

//   Future<void> _simulateBarcodeScan() async {
//     if (_isScanning) return;

//     setState(() {
//       _isScanning = true;
//     });

//     // Simulate scanning delay
//     await Future.delayed(const Duration(milliseconds: 1500));

//     // Mock barcode data for demonstration
//     final mockBarcodes = [
//       '1234567890123',
//       '9876543210987',
//       '5555666677778',
//       '1111222233334',
//     ];

//     final randomBarcode =
//         mockBarcodes[DateTime.now().millisecond % mockBarcodes.length];

//     setState(() {
//       _isScanning = false;
//     });

//     widget.onBarcodeScanned(randomBarcode);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: _buildCameraView(),
//             ),
//             _buildControls(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(4.w),
//       color: Colors.black.withValues(alpha: 0.8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Scan Barcode',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//           IconButton(
//             onPressed: widget.onClose,
//             icon: CustomIconWidget(
//               iconName: 'close',
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCameraView() {
//     if (_errorMessage != null) {
//       return _buildErrorView();
//     }

//     if (!_isInitialized || _cameraController == null) {
//       return _buildLoadingView();
//     }

//     return Stack(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: CameraPreview(_cameraController!),
//         ),
//         _buildScanningOverlay(),
//       ],
//     );
//   }

//   Widget _buildErrorView() {
//     return Container(
//       width: double.infinity,
//       color: Colors.black,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CustomIconWidget(
//             iconName: 'error_outline',
//             color: Colors.red,
//             size: 48,
//           ),
//           SizedBox(height: 2.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.w),
//             child: Text(
//               _errorMessage!,
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: Colors.white,
//                   ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _errorMessage = null;
//               });
//               _initializeCamera();
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingView() {
//     return Container(
//       width: double.infinity,
//       color: Colors.black,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             color: Colors.white,
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             'Initializing camera...',
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   color: Colors.white,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScanningOverlay() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: Stack(
//         children: [
//           // Dark overlay with transparent center
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black.withValues(alpha: 0.5),
//             ),
//             child: Center(
//               child: Container(
//                 width: 60.w,
//                 height: 30.h,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: _isScanning ? Colors.green : Colors.white,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: _isScanning
//                     ? Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.green,
//                           ),
//                         ),
//                       )
//                     : null,
//               ),
//             ),
//           ),
//           // Instructions
//           Positioned(
//             bottom: 20.h,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8.w),
//               child: Text(
//                 'Position the barcode within the frame to scan',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildControls() {
//     return Container(
//       padding: EdgeInsets.all(4.w),
//       color: Colors.black.withValues(alpha: 0.8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // Flash toggle (mobile only)
//           if (!kIsWeb)
//             IconButton(
//               onPressed: _toggleFlash,
//               icon: CustomIconWidget(
//                 iconName: 'flash_on',
//                 color: Colors.white,
//                 size: 28,
//               ),
//             ),
//           // Scan button
//           ElevatedButton.icon(
//             onPressed: _isScanning ? null : _simulateBarcodeScan,
//             icon: _isScanning
//                 ? SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: const CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                 : CustomIconWidget(
//                     iconName: 'qr_code_scanner',
//                     color: Colors.white,
//                     size: 20,
//                   ),
//             label: Text(_isScanning ? 'Scanning...' : 'Scan'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).colorScheme.primary,
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
//             ),
//           ),
//           // Manual input button
//           TextButton.icon(
//             onPressed: _showManualInputDialog,
//             icon: CustomIconWidget(
//               iconName: 'keyboard',
//               color: Colors.white,
//               size: 20,
//             ),
//             label: const Text('Manual'),
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _toggleFlash() async {
//     if (_cameraController == null || !_isInitialized) return;

//     try {
//       final currentFlashMode = _cameraController!.value.flashMode;
//       final newFlashMode =
//           currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;

//       await _cameraController!.setFlashMode(newFlashMode);
//     } catch (e) {
//       // Flash not supported
//     }
//   }

//   void _showManualInputDialog() {
//     final controller = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Enter Barcode'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             hintText: 'Enter barcode manually',
//             border: OutlineInputBorder(),
//           ),
//           keyboardType: TextInputType.number,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final barcode = controller.text.trim();
//               if (barcode.isNotEmpty) {
//                 Navigator.pop(context);
//                 widget.onBarcodeScanned(barcode);
//               }
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
