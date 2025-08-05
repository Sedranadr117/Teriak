// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';

// class BarcodeScannerWidget extends StatefulWidget {
//   final Function(String) onBarcodeScanned;
//   final bool isRTL;

//   const BarcodeScannerWidget({
//     super.key,
//     required this.onBarcodeScanned,
//     this.isRTL = false,
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

//   Future<bool> _requestCameraPermission() async {
//     if (kIsWeb) return true;
//     final status = await Permission.camera.request();
//     return status.isGranted;
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       if (!await _requestCameraPermission()) {
//         setState(() {
//           _errorMessage = widget.isRTL
//               ? 'يرجى السماح بالوصول للكاميرا'
//               : 'Camera permission required';
//         });
//         return;
//       }

//       _cameras = await availableCameras();
//       if (_cameras.isEmpty) {
//         setState(() {
//           _errorMessage =
//               widget.isRTL ? 'لا توجد كاميرا متاحة' : 'No camera available';
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
//       );

//       await _cameraController!.initialize();
//       await _applySettings();

//       if (mounted) {
//         setState(() {
//           _isInitialized = true;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = widget.isRTL
//             ? 'خطأ في تشغيل الكاميرا'
//             : 'Camera initialization failed';
//       });
//     }
//   }

//   Future<void> _applySettings() async {
//     if (_cameraController == null) return;

//     try {
//       await _cameraController!.setFocusMode(FocusMode.auto);
//     } catch (e) {
//       // Focus mode not supported, continue
//     }

//     if (!kIsWeb) {
//       try {
//         await _cameraController!.setFlashMode(FlashMode.auto);
//       } catch (e) {
//         // Flash not supported, continue
//       }
//     }
//   }

//   void _simulateBarcodeDetection() {
//     if (_isScanning) return;

//     setState(() {
//       _isScanning = true;
//     });

//     // Simulate barcode detection for demo purposes
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         final mockBarcodes = [
//           '1234567890123',
//           '9876543210987',
//           '5555666677778',
//           '1111222233334',
//         ];

//         final randomBarcode =
//             mockBarcodes[DateTime.now().millisecond % mockBarcodes.length];
//         widget.onBarcodeScanned(randomBarcode);

//         setState(() {
//           _isScanning = false;
//         });

//         Navigator.pop(context);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         title: Text(
//           widget.isRTL ? 'مسح الباركود' : 'Scan Barcode',
//           style: theme.textTheme.titleLarge?.copyWith(
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: CustomIconWidget(
//             iconName: 'close',
//             color: Colors.white,
//             size: 24,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     final theme = Theme.of(context);

//     if (_errorMessage != null) {
//       return _buildErrorView(theme);
//     }

//     if (!_isInitialized) {
//       return _buildLoadingView(theme);
//     }

//     return _buildCameraView(theme);
//   }

//   Widget _buildErrorView(ThemeData theme) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(6.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomIconWidget(
//               iconName: 'camera_alt_outlined',
//               color: Colors.white,
//               size: 64,
//             ),
//             SizedBox(height: 3.h),
//             Text(
//               _errorMessage!,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 3.h),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _errorMessage = null;
//                 });
//                 _initializeCamera();
//               },
//               child: Text(
//                 widget.isRTL ? 'إعادة المحاولة' : 'Retry',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingView(ThemeData theme) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             color: Colors.white,
//           ),
//           SizedBox(height: 3.h),
//           Text(
//             widget.isRTL ? 'تشغيل الكاميرا...' : 'Initializing camera...',
//             style: theme.textTheme.titleMedium?.copyWith(
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCameraView(ThemeData theme) {
//     return Stack(
//       children: [
//         // Camera Preview
//         Positioned.fill(
//           child: CameraPreview(_cameraController!),
//         ),

//         // Overlay
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.black.withValues(alpha: 0.5),
//             ),
//           ),
//         ),

//         // Scanning Frame
//         Center(
//           child: Container(
//             width: 70.w,
//             height: 30.h,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: _isScanning ? Colors.green : Colors.white,
//                 width: 3,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: _isScanning
//                 ? Container(
//                     decoration: BoxDecoration(
//                       color: Colors.green.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const CircularProgressIndicator(
//                             color: Colors.green,
//                           ),
//                           SizedBox(height: 2.h),
//                           Text(
//                             widget.isRTL ? 'جاري المسح...' : 'Scanning...',
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               color: Colors.green,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//         ),

//         // Instructions
//         Positioned(
//           bottom: 25.h,
//           left: 0,
//           right: 0,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 6.w),
//             child: Text(
//               widget.isRTL
//                   ? 'ضع الباركود داخل الإطار للمسح'
//                   : 'Place barcode within the frame to scan',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),

//         // Scan Button
//         Positioned(
//           bottom: 10.h,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: GestureDetector(
//               onTap: _isScanning ? null : _simulateBarcodeDetection,
//               child: Container(
//                 width: 20.w,
//                 height: 20.w,
//                 decoration: BoxDecoration(
//                   color: _isScanning ? Colors.grey : Colors.white,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 4,
//                   ),
//                 ),
//                 child: Center(
//                   child: CustomIconWidget(
//                     iconName:
//                         _isScanning ? 'hourglass_empty' : 'qr_code_scanner',
//                     color: _isScanning ? Colors.white : Colors.black,
//                     size: 32,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // Manual Input Button
//         Positioned(
//           bottom: 3.h,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: TextButton(
//               onPressed: () => _showManualInputDialog(context),
//               child: Text(
//                 widget.isRTL ? 'إدخال يدوي' : 'Manual Input',
//                 style: theme.textTheme.titleSmall?.copyWith(
//                   color: Colors.white,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showManualInputDialog(BuildContext context) {
//     final theme = Theme.of(context);
//     final controller = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           widget.isRTL ? 'إدخال الباركود يدوياً' : 'Enter Barcode Manually',
//         ),
//         content: TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: widget.isRTL ? 'رقم الباركود' : 'Barcode Number',
//             hintText:
//                 widget.isRTL ? 'أدخل رقم الباركود' : 'Enter barcode number',
//           ),
//           keyboardType: TextInputType.number,
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               widget.isRTL ? 'إلغاء' : 'Cancel',
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final barcode = controller.text.trim();
//               if (barcode.isNotEmpty) {
//                 Navigator.pop(context);
//                 widget.onBarcodeScanned(barcode);
//                 Navigator.pop(context);
//               }
//             },
//             child: Text(
//               widget.isRTL ? 'تأكيد' : 'Confirm',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
