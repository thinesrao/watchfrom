import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/api/tmdb_repository.dart';
import 'package:watchfrom/data/repositories/search_history_repository.dart';
import 'package:watchfrom/data/repositories/watchlist_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final token = dotenv.env['TMDB_API_READ_ACCESS_TOKEN']!;
  return Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  ));
});

final tmdbRepositoryProvider = Provider<TmdbRepository>((ref) {
  return TmdbRepository(ref.watch(dioProvider));
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

final searchHistoryRepositoryProvider =
    Provider<SearchHistoryRepository>((ref) {
  return SearchHistoryRepository();
});
