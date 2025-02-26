import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/widgets/text_widget.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLatLng;

  const LocationPickerScreen({super.key, this.initialLatLng});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(0, 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    LatLng initialPosition = widget.initialLatLng ?? const LatLng(0, 0);

    if (widget.initialLatLng == null) {
      try {
        Position position = await _determinePosition();
        initialPosition = LatLng(position.latitude, position.longitude);
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    }

    setState(() {
      _selectedLocation = initialPosition;
      _isLoading = false;
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(initialPosition));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
    });
  }

  Future<void> _handleSearch() async {
    Prediction? p = await PlacesAutocomplete.show(
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
      components: [Component(Component.country, "ph")],
    );

    if (p != null) {
      _displaySearchedLocation(p.placeId!);
    }
  }

  Future<void> _displaySearchedLocation(String placeId) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(placeId);

    final double lat = detail.result.geometry!.location.lat;
    final double lng = detail.result.geometry!.location.lng;

    LatLng searchedLocation = LatLng(lat, lng);

    setState(() {
      _selectedLocation = searchedLocation;
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(searchedLocation));
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = currentLocation;
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
    } catch (e) {
      debugPrint("Error moving to current location: $e");
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
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onCameraMove: _onCameraMove,
                  markers: {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: _selectedLocation,
                      draggable: false, // Marker is not draggable
                    ),
                  },
                  myLocationButtonEnabled:
                      true, // Enable the "My Location" button
                  myLocationEnabled:
                      true, // Enable the blue dot for current location
                ),
                const Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _selectedLocation);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: TextWidget(
                          align: TextAlign.center,
                          text: "Set Delivery Address",
                          fontSize: 20,
                          color: white,
                          fontFamily: 'Bold',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
