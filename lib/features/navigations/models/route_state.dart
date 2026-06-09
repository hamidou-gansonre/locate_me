import 'package:latlong2/latlong.dart';

enum NavigationStatus {
  idle,
  loading,
  ready,
  navigation,
  arrived,
}

class RouteState {
  final List<LatLng> routePoints;
  final LatLng? animatedMarkerPos;
  final double? animatedMarkerBearing;
  final NavigationStatus status;
  final double? distanceMeters;
  final double? durationSeconds;
  final int currentSegmentIndex;
  final String? errorMessage;

  const RouteState({
    this.routePoints = const [],
    this.animatedMarkerPos,
    this.animatedMarkerBearing,
    this.status = NavigationStatus.idle,
    this.distanceMeters,
    this.durationSeconds,
    this.currentSegmentIndex = 0,
    this.errorMessage,
  });

  RouteState copyWith({
    List<LatLng>? routePoints,
    LatLng? animatedMarkerPos,
    double? animatedMarkerBearing,
    NavigationStatus? status,
    double? distanceMeters,
    double? durationSeconds,
    int? currentSegmentIndex,
    String? errorMessage,
  }) {
    return RouteState(
      routePoints: routePoints ?? this.routePoints,
      animatedMarkerPos: animatedMarkerPos ?? this.animatedMarkerPos,
      animatedMarkerBearing: animatedMarkerBearing ?? this.animatedMarkerBearing,
      status: status ?? this.status,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

