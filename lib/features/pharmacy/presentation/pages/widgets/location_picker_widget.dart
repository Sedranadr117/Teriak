import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _currentLatLng;
  late final MapController _mapController;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLatLng ??= latLng;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_currentLatLng!, 16.0);
      });

      _getAddressFromLatLng(_currentLatLng!);
    } catch (e) {
      print("⚠️ Error getting location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final result = await NominatimGeocoding().reverseGeoCoding(
        Coordinate(latitude: latLng.latitude, longitude: latLng.longitude),
      );
      print('📍 Address: ${result.address.toString()}');
      String MyAddress = "${result.address.country.toString()},"
          "${result.address.state.toString()},"
          "${result.address.road.toString()},"
          " ${result.address.houseNumber.toString()}";
      setState(() {
        _currentAddress = MyAddress;
      });
    } catch (e) {
      print('❌ Error reverse geocoding: $e');
      setState(() {
        _currentAddress = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick your pharmacy location')),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLatLng,
                zoom: 16.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _currentLatLng = point;
                  });
                  _getAddressFromLatLng(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.teriak',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLatLng!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: _currentLatLng != null
          ? FloatingActionButton.extended(
              onPressed: () {
                print('📍 Selected location: $_currentLatLng');
                Get.back(result: {
                  'latLng': _currentLatLng,
                  'address': _currentAddress,
                });
              },
              label: const Text("Confirm"),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
