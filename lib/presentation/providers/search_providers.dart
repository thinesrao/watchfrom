import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart' show SearchResult, MediaType;
import 'package:watchfrom/presentation/providers/repository_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<List<SearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return ref.read(tmdbRepositoryProvider).searchMulti(query);
});

typedef WatchProviderParams = ({int id, MediaType mediaType});

final watchProvidersProvider = FutureProvider.autoDispose
    .family<List<CountryAvailability>, WatchProviderParams>(
  (ref, params) async {
    return ref
        .read(tmdbRepositoryProvider)
        .getWatchProviders(params.id, params.mediaType);
  },
);
