import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/screens/watchlist_screen.dart';

void main() {
  group('WatchlistScreen', () {
    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchlistProvider
                .overrideWith(() => _FakeWatchlistNotifier([])),
          ],
          child: const MaterialApp(home: WatchlistScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your watchlist is empty'), findsOneWidget);
    });

    testWidgets('shows watchlist items with provider summary',
        (tester) async {
      final items = [
        WatchlistItem(
          tmdbId: 27205,
          title: 'Inception',
          mediaType: MediaType.movie,
          releaseYear: '2010',
          savedAt: DateTime.utc(2026, 8, 24),
          availabilitySnapshot: {
            'US': [
              const WatchProvider(
                providerId: 8,
                providerName: 'Netflix',
                logoPath: '/netflix.jpg',
                providerType: ProviderType.flatrate,
              ),
            ],
            'GB': [
              const WatchProvider(
                providerId: 8,
                providerName: 'Netflix',
                logoPath: '/netflix.jpg',
                providerType: ProviderType.flatrate,
              ),
            ],
          },
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchlistProvider
                .overrideWith(() => _FakeWatchlistNotifier(items)),
          ],
          child: const MaterialApp(home: WatchlistScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inception'), findsOneWidget);
      expect(find.textContaining('Netflix'), findsOneWidget);
    });
  });
}

class _FakeWatchlistNotifier extends WatchlistNotifier {
  _FakeWatchlistNotifier(this._items);
  final List<WatchlistItem> _items;

  @override
  FutureOr<List<WatchlistItem>> build() => _items;
}
