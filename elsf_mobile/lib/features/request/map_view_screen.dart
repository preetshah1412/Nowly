import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/providers.dart';

class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(37.0, -122.0), zoom: 14),
        myLocationEnabled: true,
        onLongPress: (p) => ref.read(requestControllerProvider.notifier).setLocation(p),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => ref.read(requestControllerProvider.notifier).submit(), child: const Icon(Icons.check)),
    );
  }
}
