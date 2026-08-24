import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/data/repositories/watchlist_repository.dart';

void main() {
  late Directory tempDir;
  late WatchlistRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('watchlist_test_');
    Hive.init(tempDir.path);
    repo = WatchlistRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  WatchlistItem makeItem({int tmdbId = 27205, String title = 'Inception'}) {
    return WatchlistItem(
      tmdbId: tmdbId,
      title: title,
      mediaType: MediaType.movie,
      posterPath: '/poster.jpg',
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
      },
    );
  }

  group('WatchlistRepository', () {
    test('save and getAll returns saved item', () async {
      final item = makeItem();
      await repo.save(item);

      final items = await repo.getAll();

      expect(items.length, 1);
      expect(items.first.tmdbId, 27205);
      expect(items.first.title, 'Inception');
      expect(items.first.availabilitySnapshot['US']!.first.providerName,
          'Netflix');
    });

    test('exists returns true for saved item', () async {
      await repo.save(makeItem());

      expect(await repo.exists(27205), isTrue);
      expect(await repo.exists(99999), isFalse);
    });

    test('delete removes item', () async {
      await repo.save(makeItem());
      await repo.delete(27205);

      final items = await repo.getAll();
      expect(items, isEmpty);
    });

    test('save overwrites item with same tmdbId', () async {
      await repo.save(makeItem(title: 'Old Title'));
      await repo.save(makeItem(title: 'New Title'));

      final items = await repo.getAll();
      expect(items.length, 1);
      expect(items.first.title, 'New Title');
    });

    test('getAll returns items sorted by savedAt descending', () async {
      await repo.save(WatchlistItem(
        tmdbId: 1,
        title: 'Older',
        mediaType: MediaType.movie,
        savedAt: DateTime.utc(2026, 1, 1),
        availabilitySnapshot: {},
      ));
      await repo.save(WatchlistItem(
        tmdbId: 2,
        title: 'Newer',
        mediaType: MediaType.tv,
        savedAt: DateTime.utc(2026, 8, 24),
        availabilitySnapshot: {},
      ));

      final items = await repo.getAll();
      expect(items.first.title, 'Newer');
      expect(items.last.title, 'Older');
    });
  });
}
