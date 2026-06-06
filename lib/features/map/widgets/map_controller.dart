import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/features/map/providers/location_provider.dart';
import 'package:locate_me/features/map/providers/map_controller_provider.dart';

class MapController extends ConsumerWidget {
  const MapController({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSatellite = ref.watch(isSatelliteProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ControlButton(
          icon: isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded,
          tooltip: isSatellite ? 'Street map' : 'Satellite View',
          onTap: () =>
              ref.read(isSatelliteProvider.notifier).state = !isSatellite,
        ),
        const SizedBox(height: 8),

        //Recenter
        _ControlButton(
          icon: Icons.my_location_rounded,
          tooltip: 'Ma Location',
          color: Colors.blueAccent,
          onTap: () {
            final position = ref.read(locationProvider).position;
            if (position != null) {
              ref.read(mapControllerProvider).moveSmooth(position);
            }
          },
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 3,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, size: 20, color: color ?? Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}
