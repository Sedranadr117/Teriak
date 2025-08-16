import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<void> showBarcodeScannerBottomSheet({
  required Function(String) onScanned,
}) async {
  bool scanned = false; 

  await Get.bottomSheet(
    Container(
      height: Get.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: _ScannerSheet(onScanned: (value) {
        if (!scanned) {
          scanned = true;
          onScanned(value);
          Get.back();
        }
      }),
    ),
    isScrollControlled: true,
  );
}

class _ScannerSheet extends StatefulWidget {
  final Function(String) onScanned;

  const _ScannerSheet({required this.onScanned});

  @override
  State<_ScannerSheet> createState() => _ScannerSheetState();
}

class _ScannerSheetState extends State<_ScannerSheet> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                "Scan Barcode".tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
        ),
        Expanded(
          child: MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final value = barcode.rawValue;
              if (value != null) {
                widget.onScanned(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
