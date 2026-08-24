// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    _SearchResult(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      posterPath: json['posterPath'] as String?,
      releaseYear: json['releaseYear'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SearchResultToJson(_SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'posterPath': instance.posterPath,
      'releaseYear': instance.releaseYear,
      'overview': instance.overview,
      'voteAverage': instance.voteAverage,
    };

const _$MediaTypeEnumMap = {MediaType.movie: 'movie', MediaType.tv: 'tv'};
