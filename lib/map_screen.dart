import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// Added explicit flutter_map package import as requested
import 'package:latlong2/latlong.dart';
import 'package:locate_me/core/utils/app_constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialZoom: AppConstants.defaultZoom,
              initialCenter: LatLng(12.2595, -1.3101),
            ),
            children: [
              TileLayer(
                maxZoom: 19,
                urlTemplate: AppConstants.defaultMapTileUrl,
                userAgentPackageName: 'com.exemple.locate_me',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
