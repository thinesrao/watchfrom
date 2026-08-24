import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/repository_providers.dart';

final watchlistProvider =
    AsyncNotifierProvider<WatchlistNotifier, List<WatchlistItem>>(
  WatchlistNotifier.new,
);

class WatchlistNotifier extends AsyncNotifier<List<WatchlistItem>> {
  @override
  FutureOr<List<WatchlistItem>> build() {
    return ref.read(watchlistRepositoryProvider).getAll();
  }

  Future<void> add(WatchlistItem item) async {
    await ref.read(watchlistRepositoryProvider).save(item);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(int tmdbId) async {
    await ref.read(watchlistRepositoryProvider).delete(tmdbId);
    ref.invalidateSelf();
    await future;
  }

  Future<bool> exists(int tmdbId) {
    return ref.read(watchlistRepositoryProvider).exists(tmdbId);
  }
}
