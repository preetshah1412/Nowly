import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
      final asked = await Geolocator.requestPermission();
      return asked == LocationPermission.always || asked == LocationPermission.whileInUse;
    }
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }
  Future<Position?> currentPosition() async {
    final ok = await ensurePermission();
    if (!ok) return null;
    return Geolocator.getCurrentPosition();
  }
}
