import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchBarWidget<T> extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBarcodeScanned;
  final bool isScanner;
  final VoidCallback? onClear;
  final List<T> results;
  final bool isSearching;
  final Widget Function(T item) itemBuilder;
  final void Function(T item) onItemTap;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBarcodeScanned,
    required this.results,
    required this.isSearching,
    required this.itemBuilder,
    required this.onItemTap,
    required this.hintText,
    this.onClear,
    required this.isScanner,
  });

  @override
  State<SearchBarWidget<T>> createState() => _SearchBarWidgetState<T>();
}

class _SearchBarWidgetState<T> extends State<SearchBarWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.sp),
                child: Icon(Icons.search,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear,
                          size: 15.sp,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged('');
                        widget.onClear?.call();
                        setState(() {});
                      },
                    ),
                  Container(
                    width: 1,
                    height: 10.sp,
                    color: Theme.of(context).colorScheme.outline.withAlpha(77),
                  ),
                  widget.isScanner
                      ? IconButton(
                          icon: Icon(Icons.qr_code_scanner_rounded,
                              size: 24.sp,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: widget.onBarcodeScanned,
                        )
                      : SizedBox()
                ],
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
            ),
          ),
          if ((widget.controller.text.isNotEmpty || widget.isSearching) &&
              widget.results.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 0, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border:
                    Border.all(color: Theme.of(context).hintColor, width: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: widget.isSearching
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.results.length,
                      itemBuilder: (context, index) {
                        final item = widget.results[index];
                        return InkWell(
                          onTap: () => widget.onItemTap(item),
                          child: widget.itemBuilder(item),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
