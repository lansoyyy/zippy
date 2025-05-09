import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:google_maps_webservice/geocoding.dart' as geocoding;
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/widgets/text_widget.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLatLng;
  final String? initialLocationName;

  const LocationPickerScreen({
    super.key,
    this.initialLatLng,
    this.initialLocationName,
  });

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(0, 0);
  String _locationName = 'Select a location';
  String _plusCode = '';
  bool _isLoading = true;
  bool _isNavigating = false;
  late geocoding.GoogleMapsGeocoding _geocoding;
  Timer? _debounce;
  final bool _isSearchSelected = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _geocoding = geocoding.GoogleMapsGeocoding(apiKey: kGoogleApiKey);
    _initializeLocation();
  }

  String _generatePlusCode(LatLng position) {
    // This is a simplified version - in production, use a proper Plus Code implementation
    final lat = position.latitude;
    final lng = position.longitude;
    final latStr = lat.toStringAsFixed(2).replaceAll('.', '').padLeft(4, '0');
    final lngStr = lng.toStringAsFixed(2).replaceAll('.', '').padLeft(4, '0');
    return '${latStr.substring(0, 2)}${lngStr.substring(0, 2)}+${latStr.substring(2)}${lngStr.substring(2)}';
  }

  Future<void> _initializeLocation() async {
    LatLng initialPosition = widget.initialLatLng ?? const LatLng(0, 0);
    String initialName = 'Selecting location...';
    String initialPlusCode = '';

    if (widget.initialLatLng == null) {
      try {
        Position position = await _determinePosition();
        initialPosition = LatLng(position.latitude, position.longitude);
        final locationInfo = await _getFormattedLocationInfo(initialPosition);
        initialName = locationInfo['formattedAddress'] ?? 'Selected Location';
        initialPlusCode = locationInfo['plusCode'] ?? '';
      } catch (e) {
        debugPrint("Error getting location: $e");
        initialName = 'Could not determine current location';
      }
    } else {
      final locationInfo = await _getFormattedLocationInfo(initialPosition);
      initialName = locationInfo['formattedAddress'] ?? 'Selected Location';
      initialPlusCode = locationInfo['plusCode'] ?? '';
    }

    if (mounted) {
      setState(() {
        _selectedLocation = initialPosition;
        _locationName = initialName;
        _plusCode = initialPlusCode;
        _isLoading = false;
      });
    }
  }

  Future<Map<String, String>> _getFormattedLocationInfo(LatLng position) async {
    try {
      final geocodeResponse = await _geocoding.searchByLocation(
        geocoding.Location(lat: position.latitude, lng: position.longitude),
      );

      if (geocodeResponse.results.isNotEmpty) {
        final result = geocodeResponse.results.first;
        final plusCode = _generatePlusCode(position);

        String city = '';
        String province = '';
        String country = '';

        for (var component in result.addressComponents) {
          if (component.types.contains('locality')) {
            city = component.longName;
          } else if (component.types.contains('administrative_area_level_2')) {
            city = city.isEmpty ? component.longName : city;
          } else if (component.types.contains('administrative_area_level_1')) {
            province = component.longName;
          } else if (component.types.contains('country')) {
            country = component.longName;
          }
        }

        String formattedAddress = plusCode;
        if (city.isNotEmpty) formattedAddress += ', $city';
        if (province.isNotEmpty && province != city)
          formattedAddress += ', $province';
        if (country.isNotEmpty) formattedAddress += ', $country';

        return {
          'formattedAddress': formattedAddress,
          'plusCode': plusCode,
        };
      }
    } catch (e) {
      debugPrint("Error getting formatted location info: $e");
    }

    final plusCode = _generatePlusCode(position);
    return {
      'formattedAddress':
          '$plusCode, Location at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
      'plusCode': plusCode,
    };
  }

  Future<String> _getAddressName(LatLng position) async {
    try {
      final geocodeResponse = await _geocoding.searchByLocation(
        geocoding.Location(lat: position.latitude, lng: position.longitude),
      );

      if (geocodeResponse.results.isNotEmpty) {
        final result = geocodeResponse.results.first;

        if (result.formattedAddress != null &&
            result.formattedAddress!.isNotEmpty) {
          return result.formattedAddress!;
        }

        String address = '';
        for (var component in result.addressComponents) {
          if (component.types.contains('street_number')) {
            address = '${component.longName} ';
          } else if (component.types.contains('route')) {
            address += component.longName;
          } else if (component.types.contains('locality') && address.isEmpty) {
            address = component.longName;
          } else if (component.types.contains('administrative_area_level_1') &&
              address.isEmpty) {
            address = component.longName;
          }
        }

        if (address.isNotEmpty) return address;
        if (result.addressComponents.isNotEmpty) {
          return result.addressComponents.first.longName;
        }
      }

      return 'Nearby location at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    } catch (e) {
      debugPrint("Error getting address name: $e");
      return 'Location at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'Location services are disabled.';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        throw 'Location permissions are denied.';
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onCameraMoveStarted() {
    setState(() {
      _isDragging = true;
    });
  }

  void _onCameraMove(CameraPosition position) {
    if (!mounted) return;
    _selectedLocation = position.target;
  }

  void _onCameraIdle() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isDragging = false;
      });

      try {
        final locationInfo = await _getFormattedLocationInfo(_selectedLocation);
        if (mounted) {
          setState(() {
            _locationName =
                locationInfo['formattedAddress'] ?? 'Selected Location';
            _plusCode = locationInfo['plusCode'] ?? '';
          });
        }
      } catch (e) {
        debugPrint("Error in camera idle: $e");
        if (mounted) {
          setState(() {
            _locationName =
                '${_generatePlusCode(_selectedLocation)}, Location at ${_selectedLocation.latitude.toStringAsFixed(4)}, ${_selectedLocation.longitude.toStringAsFixed(4)}';
            _plusCode = _generatePlusCode(_selectedLocation);
          });
        }
      }
    });
  }

  Future<void> _handleSearch() async {
    try {
      places.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
          hintText: 'Search Address',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        components: [places.Component(places.Component.country, "ph")],
      );

      if (p != null) {
        await _displaySearchedLocation(p.placeId!);
      }
    } catch (e) {
      debugPrint("Search error: $e");
    }
  }

  Future<void> _displaySearchedLocation(String placeId) async {
    try {
      final placesService = places.GoogleMapsPlaces(apiKey: kGoogleApiKey);
      final detail = await placesService.getDetailsByPlaceId(placeId);

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      final searchedLocation = LatLng(lat, lng);

      final locationInfo = await _getFormattedLocationInfo(searchedLocation);

      if (mounted) {
        setState(() {
          _selectedLocation = searchedLocation;
          _locationName =
              locationInfo['formattedAddress'] ?? 'Selected Location';
          _plusCode = locationInfo['plusCode'] ?? '';
        });
      }

      await _mapController.animateCamera(
        CameraUpdate.newLatLng(searchedLocation),
      );
    } catch (e) {
      debugPrint("Error displaying location: $e");
    }
  }

  Future<void> _returnWithLocation() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;
      Navigator.of(context).pop({
        'location': _selectedLocation,
        'name': _locationName,
        'plusCode': _plusCode,
      });
    } catch (e) {
      debugPrint("Navigation error: $e");
    } finally {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          text: "Pick a Location",
          color: secondary,
          fontSize: 20,
          fontFamily: 'Bold',
        ),
        actions: [
          IconButton(
            color: secondary,
            icon: const Icon(Icons.search),
            onPressed: _handleSearch,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  buildingsEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(_selectedLocation),
                      );
                    });
                  },
                  onCameraMoveStarted: _onCameraMoveStarted,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  // markers: {
                  //   Marker(
                  //     markerId: const MarkerId("selected"),
                  //     position: _selectedLocation,
                  //     draggable: false,
                  //     zIndex: 2,
                  //   ),
                  // },
                  myLocationButtonEnabled: true,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                  ),
                  myLocationEnabled: true,
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: _locationName,
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Medium',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        TextWidget(
                          text: 'Plus Code: $_plusCode',
                          color: Colors.grey[700]!,
                          fontSize: 12,
                          fontFamily: 'Regular',
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      if (_isDragging)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Release to confirm location',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: _returnWithLocation,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: TextWidget(
                              text: "Set Address",
                              fontSize: 18,
                              color: white,
                              fontFamily: 'Bold',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.location_pin,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
