import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/data/repositories/hive_helpers.dart';

class WatchlistRepository {
  static const _boxName = 'watchlist';

  Future<Box<dynamic>> _openBox() => Hive.openBox(_boxName);

  Future<void> save(WatchlistItem item) async {
    final box = await _openBox();
    await box.put(item.tmdbId.toString(), item.toJson());
  }

  Future<List<WatchlistItem>> getAll() async {
    final box = await _openBox();
    final items = box.values
        .map((value) => WatchlistItem.fromJson(deepCastMap(value as Map)))
        .toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  Future<void> delete(int tmdbId) async {
    final box = await _openBox();
    await box.delete(tmdbId.toString());
  }

  Future<bool> exists(int tmdbId) async {
    final box = await _openBox();
    return box.containsKey(tmdbId.toString());
  }
}
