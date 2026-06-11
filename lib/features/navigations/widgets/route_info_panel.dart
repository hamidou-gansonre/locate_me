import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/features/navigations/models/route_state.dart';
import 'package:locate_me/features/navigations/providers/route_provider.dart';
import 'package:locate_me/features/search/providers/search_provider.dart';

class RouteInfoPanel extends ConsumerWidget {
  const RouteInfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeProvider);
    final place = ref.watch(selectedPlaceProvider);

    if (route.status == NavigationStatus.idle ||
        route.status == NavigationStatus.loading) {
      return const SizedBox.shrink();
    }

    final isNavigating = route.status == NavigationStatus.navigation;
    final isArrived = route.status == NavigationStatus.arrived;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //HEader
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isArrived
                  ? Colors.green
                  : isNavigating
                  ? Colors.blue
                  : Colors.blueAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  isArrived
                      ? Icons.check_circle_rounded
                      : isNavigating
                      ? Icons.navigation_rounded
                      : Icons.route_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      isArrived
                          ? 'Vous êtes arrivé a destination'
                          : isNavigating
                          ? 'En cours de route...'
                          : 'Itineraire prêt',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                if (!isArrived && !isNavigating) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          ref.read(routeProvider.notifier).startNavigation(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(routeProvider.notifier).clearRoute(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),

                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // -- Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.straighten_rounded,
                        label: route.status == NavigationStatus.navigation
                            ? 'Reste '
                            : 'Distance',
                        value: route.status == NavigationStatus.navigation
                            ? route.remainingDistanceText
                            : route.distanceText,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(
                        icon: Icons.access_time_rounded,
                        label: route.status == NavigationStatus.navigation
                            ? 'ETA'
                            : 'Duration',
                        value: route.status == NavigationStatus.navigation
                            ? route.remainingDurationText
                            : route.durationText,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Stat

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Stat({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
