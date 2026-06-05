import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:locate_me/core/utils/app_constants.dart';



final mapControllerProvider  = Provider<MapController>((ref) {
  final controller = MapController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

//Map Layer Toggle
final isSatelliteProvider = StateProvider<bool>((ref) => false);

//Extension Helper
extension MapControllerX on MapController {
  void moveSmooth(LatLng center, {double zoom = AppConstants.defaultZoom}) {
    move(center, zoom);
  }
}