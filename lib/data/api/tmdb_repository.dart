import 'package:dio/dio.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/domain/countries.dart';

class TmdbRepository {
  TmdbRepository(this._dio);

  final Dio _dio;

  Future<List<SearchResult>> searchMulti(String query) async {
    final response = await _dio.get(
      '/search/multi',
      queryParameters: {
        'query': query,
        'include_adult': false,
      },
    );
    final results = response.data['results'] as List;
    return results
        .where((r) =>
            r['media_type'] == 'movie' || r['media_type'] == 'tv')
        .map((r) => SearchResult.fromTmdb(r as Map<String, dynamic>))
        .toList();
  }

  Future<List<CountryAvailability>> getWatchProviders(
    int id,
    MediaType mediaType,
  ) async {
    final path = mediaType == MediaType.movie
        ? '/movie/$id/watch/providers'
        : '/tv/$id/watch/providers';
    final response = await _dio.get(path);
    final results =
        Map<String, dynamic>.from(response.data['results'] as Map);

    return results.entries.map((entry) {
      final code = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final providers = <WatchProvider>[];

      for (final type in ProviderType.values) {
        final list = data[type.name] as List?;
        if (list != null) {
          providers.addAll(
            list.map((p) =>
                WatchProvider.fromTmdb(p as Map<String, dynamic>, type)),
          );
        }
      }

      return CountryAvailability(
        countryCode: code,
        countryName: Countries.nameFor(code) ?? code,
        flagEmoji: Countries.flagFor(code),
        providers: providers,
      );
    }).toList();
  }
}
