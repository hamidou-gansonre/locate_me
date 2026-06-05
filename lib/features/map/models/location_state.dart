import 'package:latlong2/latlong.dart';

class LocationState {
  final LatLng? position;
  final double? heading;
  final double? speed;
  final bool isLoading;
  final String? errorMessage;

  const LocationState({
    this.position,
    this.heading,
    this.speed,
    this.isLoading = false,
    this.errorMessage,
  });

  LocationState copyWith({
    LatLng? position,
    double? heading,
    double? speed,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationState(
      position: position ?? this.position,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /* @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LocationState &&
        other.position == position &&
        other.heading == heading &&
        other.speed == speed &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(position, heading, speed, isLoading, errorMessage);
  }
  */
}
