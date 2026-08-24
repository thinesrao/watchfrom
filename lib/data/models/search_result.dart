import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

enum MediaType { movie, tv }

@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required int id,
    required String title,
    required MediaType mediaType,
    String? posterPath,
    String? releaseYear,
    String? overview,
    double? voteAverage,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  factory SearchResult.fromTmdb(Map<String, dynamic> json) {
    final isMovie = json['media_type'] == 'movie';
    final title = isMovie
        ? json['title'] as String? ?? ''
        : json['name'] as String? ?? '';
    final dateStr = isMovie
        ? json['release_date'] as String?
        : json['first_air_date'] as String?;

    return SearchResult(
      id: json['id'] as int,
      title: title,
      mediaType: isMovie ? MediaType.movie : MediaType.tv,
      posterPath: json['poster_path'] as String?,
      releaseYear: dateStr != null && dateStr.length >= 4
          ? dateStr.substring(0, 4)
          : null,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }
}
