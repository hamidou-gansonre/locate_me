import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/features/map/providers/map_controller_provider.dart';
import 'package:locate_me/features/navigations/providers/route_provider.dart';
import 'package:locate_me/features/search/models/place_models.dart';
import 'package:locate_me/features/search/providers/search_provider.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value;
      setState(() => _showSuggestions = value.length >= 3);
    });
  }

  void _onSelectPlace(PlaceModels place) {
    _controller.text = place.shortName;
    _focus.unfocus();
    setState(() => _showSuggestions = false);

    ref.read(selectedPlaceProvider.notifier).state = place;
    //For Route Provider
    ref.read(routeProvider.notifier).fetchRoute();

    final mapController = ref.read(mapControllerProvider);
    mapController.moveSmooth(place.latLng, zoom: 14);
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(selectedPlaceProvider.notifier).state = null;
    ref.read(routeProvider.notifier).clearRoute();
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = ref.watch(searchSuggestionsProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 56.0, // Donne une taille fixe à la barre de recherche
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher un Lieu...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.blueAccent,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),

        //--- suggestions dropdown
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: suggestions.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (buildContext, ints) => const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Recherche Echoué, Essayer Encore'),
              ),
              data: (places) {
                if (places.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Aucun resultat trouver.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: places.length,
                  separatorBuilder: (buildContext, ints) => Divider(
                    height: 1,
                    indent: 52,
                    color: Colors.grey.shade100,
                  ),
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return _SuggestionTile(
                          place: place,
                          onTap: () => _onSelectPlace(place),
                        )
                        .animate()
                        .fadeIn(duration: 200.ms, delay: (index * 40).ms)
                        .slideY(begin: 0.1, end: 0);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final PlaceModels place;
  final VoidCallback onTap;
  const _SuggestionTile({super.key, required this.place, required this.onTap});

  IconData _iconForType(String? type) {
    switch (type) {
      case 'restaurant':
      case 'cafe':
        return Icons.restaurant_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'school':
      case 'university':
        return Icons.school_rounded;
      case 'pharmacy':
        return Icons.local_pharmacy_rounded;
      case 'airport':
        return Icons.flight_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          _iconForType(place.type),
          size: 18,
          color: Colors.blueAccent,
        ),
      ),
      title: Text(
        place.shortName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        place.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
    );
  }
}
