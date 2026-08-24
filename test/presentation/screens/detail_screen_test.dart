import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/screens/detail_screen.dart';

const _testResult = SearchResult(
  id: 27205,
  title: 'Inception',
  mediaType: MediaType.movie,
  posterPath: '/poster.jpg',
  releaseYear: '2010',
  overview: 'A thief who steals secrets through dreams.',
  voteAverage: 8.4,
);

final _sgAvailable = [
  const CountryAvailability(
    countryCode: 'SG',
    countryName: 'Singapore',
    flagEmoji: '🇸🇬',
    providers: [
      WatchProvider(
        providerId: 8,
        providerName: 'Netflix',
        logoPath: '/netflix.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
  const CountryAvailability(
    countryCode: 'US',
    countryName: 'United States',
    flagEmoji: '🇺🇸',
    providers: [
      WatchProvider(
        providerId: 337,
        providerName: 'Disney Plus',
        logoPath: '/disney.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
];

final _sgNotAvailable = [
  const CountryAvailability(
    countryCode: 'US',
    countryName: 'United States',
    flagEmoji: '🇺🇸',
    providers: [
      WatchProvider(
        providerId: 8,
        providerName: 'Netflix',
        logoPath: '/netflix.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
  const CountryAvailability(
    countryCode: 'GB',
    countryName: 'United Kingdom',
    flagEmoji: '🇬🇧',
    providers: [
      WatchProvider(
        providerId: 8,
        providerName: 'Netflix',
        logoPath: '/netflix.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
];

void main() {
  group('DetailScreen', () {
    testWidgets('shows SG available section when SG has flatrate',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchProvidersProvider((id: 27205, mediaType: MediaType.movie))
                .overrideWith((ref) => Future.value(_sgAvailable)),
            watchlistProvider.overrideWith(
              () => _FakeWatchlistNotifier(),
            ),
          ],
          child: const MaterialApp(
            home: DetailScreen(searchResult: _testResult),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Singapore'), findsOneWidget);
      expect(find.text('Netflix'), findsWidgets);
    });

    testWidgets('shows not available banner when SG has no flatrate',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchProvidersProvider((id: 27205, mediaType: MediaType.movie))
                .overrideWith((ref) => Future.value(_sgNotAvailable)),
            watchlistProvider.overrideWith(
              () => _FakeWatchlistNotifier(),
            ),
          ],
          child: const MaterialApp(
            home: DetailScreen(searchResult: _testResult),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Not available for streaming in Singapore'),
          findsOneWidget);
    });

    testWidgets('shows availability changed banner when snapshot differs',
        (tester) async {
      final oldSnapshot = {
        'US': [
          const WatchProvider(
            providerId: 337,
            providerName: 'Disney Plus',
            logoPath: '/disney.jpg',
            providerType: ProviderType.flatrate,
          ),
        ],
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchProvidersProvider((id: 27205, mediaType: MediaType.movie))
                .overrideWith((ref) => Future.value(_sgNotAvailable)),
            watchlistProvider.overrideWith(
              () => _FakeWatchlistNotifier(),
            ),
          ],
          child: MaterialApp(
            home: DetailScreen(
              searchResult: _testResult,
              savedSnapshot: oldSnapshot,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Availability has changed since you saved this'),
        findsOneWidget,
      );
    });
  });
}

class _FakeWatchlistNotifier extends WatchlistNotifier {
  @override
  FutureOr<List<WatchlistItem>> build() => [];
}
