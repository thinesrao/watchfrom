import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';

void main() {
  group('SearchResult', () {
    test('fromTmdb parses a movie correctly', () {
      final json = {
        'id': 27205,
        'media_type': 'movie',
        'title': 'Inception',
        'release_date': '2010-07-16',
        'poster_path': '/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg',
        'overview': 'A thief who steals secrets...',
        'vote_average': 8.369,
      };

      final result = SearchResult.fromTmdb(json);

      expect(result.id, 27205);
      expect(result.title, 'Inception');
      expect(result.mediaType, MediaType.movie);
      expect(result.releaseYear, '2010');
      expect(result.posterPath, '/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg');
      expect(result.overview, 'A thief who steals secrets...');
      expect(result.voteAverage, 8.369);
    });

    test('fromTmdb parses a TV show correctly', () {
      final json = {
        'id': 1396,
        'media_type': 'tv',
        'name': 'Breaking Bad',
        'first_air_date': '2008-01-20',
        'poster_path': '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
        'overview': 'A chemistry teacher...',
        'vote_average': 8.912,
      };

      final result = SearchResult.fromTmdb(json);

      expect(result.id, 1396);
      expect(result.title, 'Breaking Bad');
      expect(result.mediaType, MediaType.tv);
      expect(result.releaseYear, '2008');
    });

    test('fromTmdb handles missing optional fields', () {
      final json = {
        'id': 999,
        'media_type': 'movie',
        'title': 'Unknown Movie',
      };

      final result = SearchResult.fromTmdb(json);

      expect(result.id, 999);
      expect(result.title, 'Unknown Movie');
      expect(result.posterPath, isNull);
      expect(result.releaseYear, isNull);
      expect(result.overview, isNull);
      expect(result.voteAverage, isNull);
    });

    test('toJson and fromJson round-trip', () {
      final original = SearchResult(
        id: 1,
        title: 'Test',
        mediaType: MediaType.movie,
        posterPath: '/test.jpg',
        releaseYear: '2024',
        overview: 'A test movie',
        voteAverage: 7.5,
      );

      final json = original.toJson();
      final restored = SearchResult.fromJson(json);

      expect(restored, original);
    });
  });
}
