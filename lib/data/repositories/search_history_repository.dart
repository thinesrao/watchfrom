import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/models/search_history_entry.dart';
import 'package:watchfrom/data/repositories/hive_helpers.dart';

class SearchHistoryRepository {
  static const _boxName = 'search_history';
  static const _maxEntries = 50;

  Future<Box<dynamic>> _openBox() => Hive.openBox(_boxName);

  Future<void> save(String query) async {
    final box = await _openBox();
    final entry = SearchHistoryEntry(
      query: query,
      searchedAt: DateTime.now(),
    );
    await box.put(query, entry.toJson());
    await _prune(box);
  }

  Future<void> _prune(Box<dynamic> box) async {
    if (box.length <= _maxEntries) return;
    final entries = box.keys.map((key) {
      final value = deepCastMap(box.get(key) as Map);
      return MapEntry(
        key,
        DateTime.parse(value['searchedAt'] as String),
      );
    }).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final toRemove = entries.take(box.length - _maxEntries);
    for (final entry in toRemove) {
      await box.delete(entry.key);
    }
  }

  Future<List<SearchHistoryEntry>> getRecent() async {
    final box = await _openBox();
    final entries = box.values
        .map((value) =>
            SearchHistoryEntry.fromJson(deepCastMap(value as Map)))
        .toList();
    entries.sort((a, b) => b.searchedAt.compareTo(a.searchedAt));
    return entries;
  }

  Future<void> deleteEntry(String query) async {
    final box = await _openBox();
    await box.delete(query);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
