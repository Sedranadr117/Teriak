import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onBarcodeScanned;
  final List<String> searchHistory;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBarcodeScanned,
    required this.searchHistory,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showSearchHistory = false;

  void _simulateBarcodeScanning() {
    // Simulate barcode scanning result
    const String mockBarcode = "123456789012";
    widget.onBarcodeScanned(mockBarcode);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Barcode scanned: $mockBarcode'),
        duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Main Search Bar
        TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() {
                _showSearchHistory = value.isEmpty && widget.focusNode.hasFocus;
              });
            },
            onTap: () {
              setState(() {
                _showSearchHistory = widget.controller.text.isEmpty;
              });
            },
            decoration: InputDecoration(
                hintText: 'Search by product name or generic name...'.tr,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
                prefixIcon: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: CustomIconWidget(
                        iconName: 'search',
                        size: 20.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (widget.controller.text.isNotEmpty)
                    IconButton(
                        icon: Icon(Icons.clear,
                            size: 15.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        onPressed: () {
                          widget.controller.clear();
                          widget.onChanged('');
                          setState(() {
                            _showSearchHistory = false;
                          });
                        }),
                  Container(
                      width: 1,
                      height: 10.sp,
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77)),
                  IconButton(
                      icon: Icon(Icons.qr_code_scanner_rounded,
                          size: 24.sp,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: _simulateBarcodeScanning,
                      tooltip: 'Scan Barcode'),
                ]),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface)),

        // Search History Dropdown
        if (_showSearchHistory && widget.searchHistory.isNotEmpty)
          Container(
              margin: EdgeInsets.only(top: 8.sp),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                      width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 8,
                        offset: const Offset(0, 4)),
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: Text('Recent Searches'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant))),
                    ...widget.searchHistory.take(5).map((history) => InkWell(
                        onTap: () {
                          widget.controller.text = history;
                          widget.onChanged(history);
                          setState(() {
                            _showSearchHistory = false;
                          });
                          widget.focusNode.unfocus();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.sp, vertical: 12.sp),
                            child: Row(children: [
                              Icon(Icons.history,
                                  size: 16.sp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              SizedBox(width: 12.sp),
                              Expanded(
                                  child: Text(history,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface))),
                            ])))),
                  ])),
      ]),
    );
  }
}
