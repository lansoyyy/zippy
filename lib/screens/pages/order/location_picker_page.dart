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
  bool _isLoading = true;
  bool _isNavigating = false;
  late geocoding.GoogleMapsGeocoding _geocoding;

  @override
  void initState() {
    super.initState();
    _geocoding = geocoding.GoogleMapsGeocoding(apiKey: kGoogleApiKey);
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
      // First try to get a place name from Places API
      final placesService = places.GoogleMapsPlaces(apiKey: kGoogleApiKey);
      final nearbyResponse = await placesService.searchNearbyWithRadius(
        places.Location(lat: position.latitude, lng: position.longitude),
        50,
      );

      if (nearbyResponse.results.isNotEmpty) {
        // If we have a place name (like a business or landmark), use that
        final place = nearbyResponse.results.first;
        if (place.name.isNotEmpty) {
          // Try to get the full address for context
          final geocodeResponse = await _geocoding.searchByLocation(
            geocoding.Location(lat: position.latitude, lng: position.longitude),
          );

          if (geocodeResponse.results.isNotEmpty) {
            final address = geocodeResponse.results.first;
            // Combine place name with locality if available
            String locality = '';
            for (var component in address.addressComponents) {
              if (component.types.contains('locality')) {
                locality = component.longName;
                break;
              }
            }

            if (locality.isNotEmpty) {
              return '${place.name}, $locality';
            }
            return place.name;
          }
          return place.name;
        }
      }

      // Fall back to reverse geocoding if no place name found
      final response = await _geocoding.searchByLocation(
        geocoding.Location(lat: position.latitude, lng: position.longitude),
      );

      if (response.results.isNotEmpty) {
        // Try to get a more detailed address
        final address = response.results.first;

        // Check if this is a specific establishment
        if (address.types.contains('establishment') ||
            address.types.contains('point_of_interest')) {
          return address.formattedAddress ?? 'Selected Location';
        }

        // Otherwise return the formatted address
        return address.formattedAddress ?? 'Selected Location';
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
      final name = detail.result.name ??
          detail.result.formattedAddress ??
          'Selected Location';

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

  // Future<void> _moveToCurrentLocation() async {
  //   try {
  //     Position position = await _determinePosition();
  //     final currentLocation = LatLng(position.latitude, position.longitude);
  //     final name = await _getAddressName(currentLocation);

  //     if (mounted) {
  //       setState(() {
  //         _selectedLocation = currentLocation;
  //         _locationName = name;
  //       });
  //     }

  //     await _mapController.animateCamera(
  //       CameraUpdate.newLatLng(currentLocation),
  //     );
  //   } catch (e) {
  //     debugPrint("Error moving to current location: $e");
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: ${e.toString()}')),
  //       );
  //     }
  //   }
  // }

  Future<void> _returnWithLocation() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    try {
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
                  myLocationButtonEnabled: true,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
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
                          text: "Set Address",
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
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     FloatingActionButton(
      //       heroTag: 'current_location',
      //       onPressed: _moveToCurrentLocation,
      //       child: const Icon(Icons.my_location),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
