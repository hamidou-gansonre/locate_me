
import 'package:latlong2/latlong.dart';

class PlaceModels {
  final String displayName;
  final String shortName;
  final LatLng latLng;
  final String? type;
  final String? icon;

  PlaceModels({
    required this.displayName,
    required this.shortName,
    required this.latLng,
    this.type,
    this.icon,
  });

  factory PlaceModels.fromJson(Map<String, dynamic> json) {
    return PlaceModels(
      displayName: json['display_name'] as String,
      shortName: _extractShortName(json['short_name'] as String),
      latLng: LatLng(
        double.parse(json['latLng']['lat'] as String),
        double.parse(json['latLng']['long'] as String),
      ),
      type: json['type'] as String?,
      icon: json['icon'] as String?,
    );
  }

  static String _extractShortName(String displayName) {
    final parts = displayName.split(',');
    return parts.length >= 2 ? '${parts[0].trim()}, ${parts[1].trim()}' : parts[0].trim();
  }
}