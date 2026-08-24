import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

part 'watchlist_item.freezed.dart';
part 'watchlist_item.g.dart';

@freezed
abstract class WatchlistItem with _$WatchlistItem {
  const factory WatchlistItem({
    required int tmdbId,
    required String title,
    required MediaType mediaType,
    String? posterPath,
    String? releaseYear,
    required DateTime savedAt,
    required Map<String, List<WatchProvider>> availabilitySnapshot,
  }) = _WatchlistItem;

  factory WatchlistItem.fromJson(Map<String, dynamic> json) =>
      _$WatchlistItemFromJson(json);
}
