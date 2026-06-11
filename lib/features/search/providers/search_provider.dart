//Dio singleton
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:locate_me/core/utils/app_constants.dart';
import 'package:locate_me/features/search/models/place_models.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.nominatimBaseUrl,
      headers: {'User-Agent': 'locateME/1.0 (amidoug7@gmail.com)'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

//Search Query Notifier
final searchQueryProvider = StateProvider<String>((ref) => '');

//AutoComplete suggestions
final searchSuggestionsProvider = FutureProvider.autoDispose<List<PlaceModels>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 3) return [];

  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get(
      '/search',
      queryParameters: {
        'q': query,
        'format': 'json',
        'limit': 5,
        'addressdetails': 1,
      },
    );

    final List data = response.data as List;
    return data
        .map((e) => PlaceModels.fromJson(e as Map<String, dynamic>))
        .toList();
    // Old code that was catching DioException and returning empty list:
  } on DioException {
    return [];
    // } catch (e) {
    // print('Search error: $e');
    //    rethrow; // Re-throw to display proper error state instead of empty results
  }
});

//Selected Destination
final selectedPlaceProvider = StateProvider<PlaceModels?>((ref) => null);
