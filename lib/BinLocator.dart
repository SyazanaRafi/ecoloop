import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Profile.dart';

// --- Custom Colors (Ensure consistency across your project) ---
const Color primaryGreen = Color(0xFF558B5C); // Main accent green
const Color cardGreen = Color(0xFFC7DAB8); // Muted green for location cards
const Color secondaryGreenText = Color(
  0xFF4A7451,
); // Darker green for header/text
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color mapBorderColor = Color(
  0xFF999999,
); // Border color for the map container

class BinLocatorPage extends StatefulWidget {
  const BinLocatorPage({super.key});

  @override
  State<BinLocatorPage> createState() => _BinLocatorPageState();
}

class _BinLocatorPageState extends State<BinLocatorPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = false;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(
      1.5586,
      103.6319,
    ), // Center of UTM campus (Example coordinates)
    zoom: 15,
  );

  // Data lokasi tong sampah
  final List<({String name, double lat, double lng, String distance})>
  _binLocations = [
    (
      name: 'BUS STOP PINTU TIMUR',
      lat: 1.5586,
      lng: 103.6319,
      distance: '100M away',
    ),
    (
      name: 'BUS STOP AUDITORIUM',
      lat: 1.5594,
      lng: 103.6328,
      distance: '280M away',
    ),
    (
      name: 'TRASH HOUSE BITARASISWA',
      lat: 1.5583,
      lng: 103.6325,
      distance: '150M away',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // --- Location and Map Logic (Unchanged) ---

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
          _updateMapLocation(position);
          _addMarkers();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is required to show nearby bins',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error getting location. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateMapLocation(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  void _addMarkers() {
    _markers.clear();

    // Add marker for current location
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add markers for bin locations
    for (final location in _binLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(location.lat, location.lng),
          infoWindow: InfoWindow(title: location.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    setState(() {});
  }

  // --- Navigasi Diperbetulkan ---
  Future<void> _navigateToLocation(
    String location,
    double lat,
    double lng,
  ) async {
    // 💡 Diperbetulkan: Gunakan skema URL yang betul untuk navigasi Google Maps
    final uri = Uri.parse('google.navigation:q=$lat,$lng');

    // Guna URL alternatif untuk web atau iOS jika yang utama gagal
    final webUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.platformDefault);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open map app or web browser.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,

      // 1. Custom App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),

      // 2. Main Body Content
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // 3. Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  // 4. Map Placeholder
                  _buildMapPlaceholder(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // 5. List of Location Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: _binLocations.map((location) {
                  // 💡 DIperbetulkan: Parameter 'latitude' dan 'longitude' kini dihantar
                  return _buildLocationCard(
                    context: context,
                    location: location.name,
                    distance: location.distance,
                    is24Hrs: true, // Hardcoded
                    latitude: location.lat, // BARU
                    longitude: location.lng, // BARU
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 100), // Space for bottom nav bar
          ],
        ),
      ),

      // 6. Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(
        context,
        1,
      ), // Index 1 is 'Bin Locator'
    );
  }

  // --- Widget Builders (Diberi parameter baru) ---

  // ... _buildCustomAppBar and _buildSearchBar methods (Unchanged) ...
  Widget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundWhite,
      elevation: 0,
      toolbarHeight: 80.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: secondaryGreenText),
        onPressed: () => Navigator.of(context).pop(), // Go back
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Image.asset('assets/ecoloop_logo.png', height: 60),
              const SizedBox(width: 8),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryGreen, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/profile_pic.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: mapBorderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: secondaryGreenText, size: 28),
          hintText: 'SEARCH LOCATION',
          hintStyle: TextStyle(
            color: secondaryGreenText,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            fontSize: 18,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: mapBorderColor, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                ),
              )
            : GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  _addMarkers();
                },
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------------
  // ⚠️ DIperbetulkan: Fungsi ini kini menerima latitude dan longitude sebagai input
  // ---------------------------------------------------------------------------------
  Widget _buildLocationCard({
    required BuildContext context,
    required String location,
    required String distance,
    required bool is24Hrs,
    required double latitude, // BARU
    required double longitude, // BARU
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: cardGreen.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Location Name
          Text(
            location,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondaryGreenText,
            ),
          ),
          const SizedBox(height: 5),

          // Type of Waste (Hardcoded as per design)
          const Text(
            'TYPE: PLASTIC, GLASS, ALUMINIUM',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: secondaryGreenText,
            ),
          ),
          const SizedBox(height: 10),

          // Distance and Status & Navigate Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Distance and Status
              Row(
                children: [
                  Text(
                    '• $distance',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '• ${is24Hrs ? 'Open 24hrs' : 'Closed'}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),

              // Navigate Button
              ElevatedButton(
                onPressed: () => _navigateToLocation(
                  location,
                  latitude,
                  longitude,
                ), // Diperbetulkan
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen.withOpacity(0.7),
                  foregroundColor: backgroundWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'NAVIGATE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundWhite,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 5.0),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        currentIndex: currentIndex,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            activeIcon: Icon(Icons.location_on),
            label: 'BIN LOCATOR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            activeIcon: Icon(Icons.lightbulb),
            label: 'LEARN',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed('/learn');
          }
        },
      ),
    );
  }
}
