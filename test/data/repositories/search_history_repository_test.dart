import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/repositories/search_history_repository.dart';

void main() {
  late Directory tempDir;
  late SearchHistoryRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('history_test_');
    Hive.init(tempDir.path);
    repo = SearchHistoryRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('SearchHistoryRepository', () {
    test('save and getRecent returns entry', () async {
      await repo.save('inception');

      final entries = await repo.getRecent();

      expect(entries.length, 1);
      expect(entries.first.query, 'inception');
    });

    test('saving same query updates timestamp', () async {
      await repo.save('inception');
      await Future.delayed(const Duration(milliseconds: 10));
      await repo.save('inception');

      final entries = await repo.getRecent();
      expect(entries.length, 1);
    });

    test('getRecent returns entries sorted newest first', () async {
      await repo.save('first');
      await Future.delayed(const Duration(milliseconds: 10));
      await repo.save('second');

      final entries = await repo.getRecent();
      expect(entries.first.query, 'second');
      expect(entries.last.query, 'first');
    });

    test('deleteEntry removes specific entry', () async {
      await repo.save('keep');
      await repo.save('remove');
      await repo.deleteEntry('remove');

      final entries = await repo.getRecent();
      expect(entries.length, 1);
      expect(entries.first.query, 'keep');
    });

    test('clearAll removes all entries', () async {
      await repo.save('one');
      await repo.save('two');
      await repo.clearAll();

      final entries = await repo.getRecent();
      expect(entries, isEmpty);
    });

    test('prunes to 50 entries', () async {
      for (int i = 0; i < 55; i++) {
        await repo.save('query_$i');
      }

      final entries = await repo.getRecent();
      expect(entries.length, 50);
    });
  });
}
