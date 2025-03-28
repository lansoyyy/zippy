import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as places;
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
  bool _isLoading = true;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    LatLng initialPosition = widget.initialLatLng ?? const LatLng(0, 0);
    String initialName = widget.initialLocationName ?? 'Select a location';

    if (widget.initialLatLng == null) {
      try {
        Position position = await _determinePosition();
        initialPosition = LatLng(position.latitude, position.longitude);
        initialName = await _getAddressName(initialPosition);
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    }

    if (mounted) {
      setState(() {
        _selectedLocation = initialPosition;
        _locationName = initialName;
        _isLoading = false;
      });
    }
  }

  Future<String> _getAddressName(LatLng position) async {
    try {
      final placesService = places.GoogleMapsPlaces(apiKey: kGoogleApiKey);
      final response = await placesService.searchNearbyWithRadius(
        places.Location(lat: position.latitude, lng: position.longitude),
        50,
      );

      if (response.results.isNotEmpty) {
        return response.results.first.name ?? 'Selected Location';
      }
      return 'Selected Location';
    } catch (e) {
      debugPrint("Error getting address name: $e");
      return 'Selected Location';
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onCameraMove(CameraPosition position) async {
    if (!mounted) return;

    setState(() {
      _selectedLocation = position.target;
    });

    final name = await _getAddressName(position.target);
    if (mounted) {
      setState(() {
        _locationName = name;
      });
    }
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
      final name = detail.result.name ?? 'Selected Location';

      final searchedLocation = LatLng(lat, lng);

      if (mounted) {
        setState(() {
          _selectedLocation = searchedLocation;
          _locationName = name;
        });
      }

      await _mapController.animateCamera(
        CameraUpdate.newLatLng(searchedLocation),
      );
    } catch (e) {
      debugPrint("Error displaying location: $e");
    }
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      final currentLocation = LatLng(position.latitude, position.longitude);
      final name = await _getAddressName(currentLocation);

      if (mounted) {
        setState(() {
          _selectedLocation = currentLocation;
          _locationName = name;
        });
      }

      await _mapController.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    } catch (e) {
      debugPrint("Error moving to current location: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _returnWithLocation() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    try {
      // Wait for any ongoing animations
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;
      Navigator.of(context).pop({
        'location': _selectedLocation,
        'name': _locationName,
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
                    // Move camera to position after map is created
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(_selectedLocation),
                      );
                    });
                  },
                  onCameraMove: _onCameraMove,
                  markers: {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: _selectedLocation,
                      draggable: false,
                    ),
                  },
                  myLocationButtonEnabled: false, // We have our own button
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
                    child: TextWidget(
                      text: _locationName,
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Medium',
                      maxLines: 2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: _returnWithLocation,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: secondary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: "Set Delivery Address",
                          fontSize: 18,
                          color: white,
                          fontFamily: 'Bold',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'current_location',
            onPressed: _moveToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
