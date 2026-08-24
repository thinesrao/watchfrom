import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchfrom/data/api/tmdb_repository.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TmdbRepository repo;

  setUp(() {
    mockDio = MockDio();
    repo = TmdbRepository(mockDio);
  });

  group('searchMulti', () {
    test('returns filtered results excluding people', () async {
      when(() => mockDio.get(
            '/search/multi',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {
              'results': [
                {
                  'id': 27205,
                  'media_type': 'movie',
                  'title': 'Inception',
                  'release_date': '2010-07-16',
                  'poster_path': '/poster.jpg',
                  'overview': 'A thief...',
                  'vote_average': 8.4,
                },
                {
                  'id': 999,
                  'media_type': 'person',
                  'name': 'Some Actor',
                },
                {
                  'id': 1396,
                  'media_type': 'tv',
                  'name': 'Breaking Bad',
                  'first_air_date': '2008-01-20',
                  'poster_path': '/bb.jpg',
                  'overview': 'A teacher...',
                  'vote_average': 8.9,
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final results = await repo.searchMulti('inception');

      expect(results.length, 2);
      expect(results[0].title, 'Inception');
      expect(results[0].mediaType, MediaType.movie);
      expect(results[1].title, 'Breaking Bad');
      expect(results[1].mediaType, MediaType.tv);
    });

    test('returns empty list when no results', () async {
      when(() => mockDio.get(
            '/search/multi',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {'results': []},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final results = await repo.searchMulti('xyznonexistent');

      expect(results, isEmpty);
    });
  });

  group('getWatchProviders', () {
    test('parses movie watch providers with SG and US', () async {
      when(() => mockDio.get('/movie/27205/watch/providers'))
          .thenAnswer((_) async => Response(
                data: {
                  'id': 27205,
                  'results': {
                    'SG': {
                      'flatrate': [
                        {
                          'provider_id': 8,
                          'provider_name': 'Netflix',
                          'logo_path': '/netflix.jpg',
                        },
                      ],
                      'rent': [
                        {
                          'provider_id': 2,
                          'provider_name': 'Apple TV',
                          'logo_path': '/apple.jpg',
                        },
                      ],
                    },
                    'US': {
                      'flatrate': [
                        {
                          'provider_id': 337,
                          'provider_name': 'Disney Plus',
                          'logo_path': '/disney.jpg',
                        },
                      ],
                    },
                  },
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final availability =
          await repo.getWatchProviders(27205, MediaType.movie);

      expect(availability.length, 2);

      final sg = availability.firstWhere((a) => a.countryCode == 'SG');
      expect(sg.countryName, 'Singapore');
      expect(sg.providers.length, 2);
      expect(
        sg.providers
            .where((p) => p.providerType == ProviderType.flatrate)
            .first
            .providerName,
        'Netflix',
      );

      final us = availability.firstWhere((a) => a.countryCode == 'US');
      expect(us.countryName, 'United States');
      expect(us.providers.length, 1);
    });

    test('uses TV endpoint for TV shows', () async {
      when(() => mockDio.get('/tv/1396/watch/providers'))
          .thenAnswer((_) async => Response(
                data: {'id': 1396, 'results': {}},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final availability =
          await repo.getWatchProviders(1396, MediaType.tv);

      expect(availability, isEmpty);
      verify(() => mockDio.get('/tv/1396/watch/providers')).called(1);
    });

    test('returns empty list when results map is empty', () async {
      when(() => mockDio.get('/movie/1/watch/providers'))
          .thenAnswer((_) async => Response(
                data: {'id': 1, 'results': {}},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final availability =
          await repo.getWatchProviders(1, MediaType.movie);

      expect(availability, isEmpty);
    });
  });
}
