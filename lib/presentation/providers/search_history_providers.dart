import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/models/search_history_entry.dart';
import 'package:watchfrom/presentation/providers/repository_providers.dart';

final searchHistoryProvider =
    AsyncNotifierProvider<SearchHistoryNotifier, List<SearchHistoryEntry>>(
  SearchHistoryNotifier.new,
);

class SearchHistoryNotifier
    extends AsyncNotifier<List<SearchHistoryEntry>> {
  @override
  FutureOr<List<SearchHistoryEntry>> build() {
    return ref.read(searchHistoryRepositoryProvider).getRecent();
  }

  Future<void> add(String query) async {
    await ref.read(searchHistoryRepositoryProvider).save(query);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(String query) async {
    await ref.read(searchHistoryRepositoryProvider).deleteEntry(query);
    ref.invalidateSelf();
    await future;
  }

  Future<void> clearAll() async {
    await ref.read(searchHistoryRepositoryProvider).clearAll();
    ref.invalidateSelf();
    await future;
  }
}
