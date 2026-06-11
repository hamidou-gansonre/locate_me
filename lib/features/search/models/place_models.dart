
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
    // Old code that was trying to access non-existent fields:
    // return PlaceModels(
    //   displayName: json['display_name'] as String,
    //   shortName: _extractShortName(json['short_name'] as String),
    //   latLng: LatLng(
    //     double.parse(json['latLng']['lat'] as String),
    //     double.parse(json['latLng']['long'] as String),
    //   ),
    //   type: json['type'] as String?,
    //   icon: json['icon'] as String?,
    // );
    
    // Updated to work with Nominatim API response
    final displayName = json['display_name'] as String?;
    if (displayName == null) {
      throw Exception('Missing display_name in API response');
    }

    final lat = json['lat'] as String?;
    final lon = json['lon'] as String?;
    if (lat == null || lon == null) {
      throw Exception('Missing lat/lon in API response');
    }

    return PlaceModels(
      displayName: displayName,
      shortName: _extractShortName(displayName),
      latLng: LatLng(
        double.parse(lat),
        double.parse(lon),
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