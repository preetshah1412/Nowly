import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/components/sos_button.dart';
import '../../../../core/presentation/components/location_status_bar.dart';
import '../../../../core/presentation/components/service_category_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  String _currentAddress = "Locating...";
  bool _isLocating = true;

  // Default to SF initially, but will move
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.4746,
  );

  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#212121"}]
  },
  {
    "elementType": "labels.icon",
    "stylers": [{"visibility": "off"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#212121"}]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [{"color": "#181818"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#2c2c2c"}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [{"color": "#373737"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#3c3c3c"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#000000"}]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Location Disabled";
        _isLocating = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = "Permission Denied";
          _isLocating = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = "Permission Denied Forever";
        _isLocating = false;
      });
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      final Position position = await Geolocator.getCurrentPosition();
      _getAddressFromLatLng(position);

      // Move camera if map is available (Mobile)
      if (kIsWeb ||
          (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ));
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Error: $e";
        _isLocating = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        setState(() {
          // e.g., "Andheri, Mumbai", or just "Mumbai, India"
          // Using locality (City) and subAdministrativeArea (District) or Country
          String city = place.locality ?? place.subAdministrativeArea ?? "";
          final String area = place.subLocality ?? place.thoroughfare ?? "";

          if (city.isEmpty) city = place.administrativeArea ?? "";

          if (area.isNotEmpty) {
            _currentAddress = "$area, $city";
          } else {
            _currentAddress = "$city, ${place.country}";
          }
          _isLocating = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Unknown Location";
        _isLocating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Map
          if (isDesktop)
            Container(
              color: const Color(0xFF212121),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.map_rounded, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Maps not supported on Desktop',
                      style: GoogleFonts.outfit(
                          color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentAddress, // Show address here on desktop too
                      style: GoogleFonts.outfit(
                          color: AppTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          else
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(_darkMapStyle);
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true, // Enable native button
            ),

          // 2. Location Status Bar (Top Center)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: LocationStatusBar(
                  location: _currentAddress,
                  isPrecise: !_isLocating,
                ).animate().slideY(
                    begin: -1, duration: 600.ms, curve: Curves.easeOutBack),
              ),
            ),
          ),

          // 3. Bottom Sheet for Services
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.25,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Emergency Services',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        ServiceCategoryCard(
                          label: 'Medical',
                          icon: Icons.medical_services_rounded,
                          color: Colors.red,
                          onTap: () {},
                        ),
                        ServiceCategoryCard(
                          label: 'Police',
                          icon: Icons.local_police_rounded,
                          color: Colors.blue,
                          onTap: () {},
                        ),
                        ServiceCategoryCard(
                          label: 'Fire',
                          icon: Icons.local_fire_department_rounded,
                          color: Colors.orange,
                          onTap: () {},
                        ),
                        ServiceCategoryCard(
                          label: 'Towing',
                          icon: Icons.car_crash_rounded,
                          color: Colors.grey.shade800,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. Floating SOS Button (Above Sheet)
          Positioned(
            right: 24,
            bottom: MediaQuery.of(context).size.height *
                0.42, // Position just above the initial sheet
            child: SOSButton(
              onPressed: () {
                // Trigger Emergency Protocol
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'SOS Activated! Contacting nearest services...')),
                );
              },
            ),
          ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
}
