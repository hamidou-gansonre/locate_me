class AppConstants {
  //OSRM Routing API endpoint
  static const String osrmBaseUrl =
      'https://router.project-osrm.org/route/v1/driving/';

  //Default Map tile Url(OpenStreetMap)
  static const String defaultMapTileUrl =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

  //Satellite Tile URL (Esri World Imagery)
  static const String satelliteTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  //Animation durations
  static const Duration markerAnimDuration = Duration(milliseconds: 50);
  static const Duration cameraAnimDuration = Duration(milliseconds: 600);
  static const Duration routeAninDuration = Duration(seconds: 1200);

  //Default camera position
  static const int markerAnimSteps = 200;
  static const double defaultZoom = 15.0;
  static const double routeZoom = 13.0;
}
