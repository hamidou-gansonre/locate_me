import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Added explicit flutter_map package import as requested
import 'package:latlong2/latlong.dart';
import 'package:locate_me/core/utils/app_constants.dart';
import 'package:locate_me/features/map/providers/location_provider.dart';
import 'package:locate_me/features/map/providers/map_controller_provider.dart';
import 'package:locate_me/features/map/widgets/custom_marker.dart';
import 'package:locate_me/features/map/widgets/map_controller.dart';
import 'package:locate_me/features/search/widgets/search_bar_widget.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  //Default map view --- Ouagadougou, Burkina Faso
  static const LatLng defaultCenter = LatLng(
    AppConstants.defaultLatitude,
    AppConstants.defaultLongitude,
  );

  //Tracks whether the map widget has finished
  bool _mapReady = false;

  //Called By MapOptions.onMapready
  void _onMapReady() {
    setState(() => _mapReady = true);

    //If Location was already resolved, recenter the map
    final pos = ref.read(locationProvider).position;
    if (pos != null) {
      ref
          .read(mapControllerProvider)
          .moveSmooth(pos, zoom: AppConstants.defaultZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Watch providers
    final location = ref.watch(locationProvider);
    final isSatellite = ref.watch(isSatelliteProvider);
    final mapController = ref.watch(mapControllerProvider);

    // Move Camera to users GPS position once it first becomes avaible
    ref.listen(locationProvider, (prev, next) {
      if (!_mapReady) return;

      // Only auto-center on the first GPS fix
      if (prev?.position == null && next.position != null) {
        ref
            .read(mapControllerProvider)
            .moveSmooth(next.position!, zoom: AppConstants.defaultZoom);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialZoom: AppConstants.defaultZoom,
              initialCenter: location.position ?? defaultCenter,
              onMapReady: _onMapReady,
              interactionOptions: const InteractionOptions(
                flags:
                    InteractiveFlag.all &
                    ~InteractiveFlag.rotate, // Disable rotation:
              ),
            ),
            children: [
              TileLayer(
                maxZoom: 19,
                urlTemplate: isSatellite
                    ? AppConstants.satelliteTileUrl
                    : AppConstants.defaultMapTileUrl,
                userAgentPackageName: 'com.exemple.locate_me',
              ),

              //Marker Layers
              MarkerLayer(
                markers: [
                  if (location.position != null)
                    Marker(
                      point: location.position!,
                      width: 50,
                      height: 50,
                      child: UserLocationMarker(heading: location.heading ?? 0),
                    ),

                  //Destination
                  // if(destination != null &&
                  // route.status != NavigationStatus.navigation)
                  // Marker(
                  //   point: destination.latlng,
                  //   width : 50,
                  //   height: 70,
                  //   child: const DestinationMarker(),
                  //    ),

                  //    if(route.animatedMarkerPos != null &&
                  //    route.status == NavigationStatus.navigation)
                  // Marker(
                  //   point: route.animatedMarkerPos!,
                  //   width: 44,
                  //   height: 44,
                  //   child: const NavigationMarker(
                  //     bearing: route.animatedMarkerBearing ?? 0 ,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),

          //---Search Bar top 
          Positioned(
            top : MediaQuery.of(context).padding.top + 12 ,
            child: const SearchBarWidget()),

          //Map Controller right
          Positioned(right: 16, bottom: 200, child: const MapController()),
          
          //--location error message
          if(location.errorMessage != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 16,
            right:16,
            child: Material( 
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        location.errorMessage!,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
