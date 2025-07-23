import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/pharmacy/presentation/widgets/location_picker_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            labelText: 'Pick your pharmacy location'.tr,
            hintText: 'Enter pharmacy address or use GPS'.tr,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isValid)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                SizedBox(width: 2.w),
                IconButton(
                  onPressed: () async {
                    final result =
                        await Get.to(() => const LocationPickerScreen());
                    if (result != null &&
                        result is Map &&
                        result['latLng'] is LatLng &&
                        result['address'] is String) {
                      // ignore: unused_local_variable
                      final LatLng latLng = result['latLng'];
                      final String address = result['address'];

                      widget.controller.text = address;
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                  icon: CustomIconWidget(
                    iconName: 'my_location',
                    color: Theme.of(context).colorScheme.primary,
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
              return 'Location address is required'.tr;
            }
            if (value.trim().length < 10) {
              return 'Please enter a complete address'.tr;
            }
            return null;
          },
        ),
      ],
    );
  }
}
