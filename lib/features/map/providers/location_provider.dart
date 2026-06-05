import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:locate_me/features/map/models/location_state.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  StreamSubscription<Position>? _sub;

  LocationNotifier() : super(const LocationState(isLoading: true)) {
    _init();
  }

  //Entry point for location fetching
  Future<void> _init() async {
    final permission = await _checkPermission();

    if (!permission) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Location permission denied',
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      state = state.copyWith(
        isLoading: false,
        position: LatLng(position.latitude, position.longitude),
        heading: position.heading,
        speed: position.speed,
      );

      _startStream();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error getting location: $e.toString()',
      );
    }
  }

  //continuous location updates
  void _startStream() {
    _sub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((position) {
          state = state.copyWith(
            position: LatLng(position.latitude, position.longitude),
            heading: position.heading,
            speed: position.speed,
          );
        });
  }

  //check and request location permissions
  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    //Only request if not already deniedor granted - never request if already granted or permanently denied
    if (permission == LocationPermission.denied) {
      //check again if a request is already in progress by catching the exception
      try {
        permission = await Geolocator.requestPermission();
      } on PermissionRequestInProgressException {
        // If a request is already in progress, we can wait for it to complete and check the permission again
        await Future.delayed(const Duration(seconds: 1));
        permission = await Geolocator.checkPermission();
      }
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(),
);
