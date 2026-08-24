import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';

void main() {
  group('WatchlistItem', () {
    test('toJson and fromJson round-trip preserves availability snapshot', () {
      final item = WatchlistItem(
        tmdbId: 27205,
        title: 'Inception',
        mediaType: MediaType.movie,
        posterPath: '/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg',
        releaseYear: '2010',
        savedAt: DateTime.utc(2026, 8, 24, 12, 0),
        availabilitySnapshot: {
          'US': [
            const WatchProvider(
              providerId: 8,
              providerName: 'Netflix',
              logoPath: '/t2yyOv40.jpg',
              providerType: ProviderType.flatrate,
            ),
          ],
          'GB': [
            const WatchProvider(
              providerId: 337,
              providerName: 'Disney Plus',
              logoPath: '/7rwgEs15.jpg',
              providerType: ProviderType.flatrate,
            ),
          ],
        },
      );

      final json = item.toJson();
      final restored = WatchlistItem.fromJson(json);

      expect(restored.tmdbId, 27205);
      expect(restored.title, 'Inception');
      expect(restored.availabilitySnapshot.keys, containsAll(['US', 'GB']));
      expect(
        restored.availabilitySnapshot['US']!.first.providerName,
        'Netflix',
      );
    });
  });
}
