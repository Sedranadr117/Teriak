import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class LocationInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isValid;
  final VoidCallback? onNext;

  const LocationInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isValid,
    this.onNext,
  });

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  bool _isLoadingLocation = false;
  final List<String> _suggestions = [
    '123 Main Street, New York, NY 10001',
    '456 Oak Avenue, Los Angeles, CA 90210',
    '789 Pine Road, Chicago, IL 60601',
    '321 Elm Street, Houston, TX 77001',
    '654 Maple Drive, Phoenix, AZ 85001',
  ];

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.length >= 3) {
      setState(() {
        _filteredSuggestions = _suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query))
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions.clear();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Mock GPS location detection
      await Future.delayed(const Duration(seconds: 2));

      // Mock current location
      const mockLocation = '123 Current Street, Your City, State 12345';
      widget.controller.text = mockLocation;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location detected successfully'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get current location'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _showSuggestions = false;
        });
      }
    }
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    if (widget.onNext != null) {
      widget.onNext!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            labelText: 'Location Address *',
            hintText: 'Enter pharmacy address',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isValid)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 20,
                  ),
                SizedBox(width: 2.w),
                IconButton(
                  onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  icon: _isLoadingLocation
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                  tooltip: 'Get current location',
                ),
              ],
            ),
          ),
          maxLines: 2,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            if (widget.onNext != null) {
              widget.onNext!();
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Location address is required';
            }
            if (value.trim().length < 10) {
              return 'Please enter a complete address';
            }
            return null;
          },
        ),

        // Address suggestions
        if (_showSuggestions)
          Container(
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            constraints: BoxConstraints(
              maxHeight: 30.h,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  dense: true,
                  leading: CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  title: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _selectSuggestion(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}
