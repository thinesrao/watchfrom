// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchlistItem _$WatchlistItemFromJson(Map<String, dynamic> json) =>
    _WatchlistItem(
      tmdbId: (json['tmdbId'] as num).toInt(),
      title: json['title'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      posterPath: json['posterPath'] as String?,
      releaseYear: json['releaseYear'] as String?,
      savedAt: DateTime.parse(json['savedAt'] as String),
      availabilitySnapshot:
          (json['availabilitySnapshot'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>)
                  .map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ),
    );

Map<String, dynamic> _$WatchlistItemToJson(_WatchlistItem instance) =>
    <String, dynamic>{
      'tmdbId': instance.tmdbId,
      'title': instance.title,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'posterPath': instance.posterPath,
      'releaseYear': instance.releaseYear,
      'savedAt': instance.savedAt.toIso8601String(),
      'availabilitySnapshot': instance.availabilitySnapshot.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
    };

const _$MediaTypeEnumMap = {MediaType.movie: 'movie', MediaType.tv: 'tv'};
