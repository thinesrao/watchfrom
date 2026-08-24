import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/repositories/hive_helpers.dart';

void main() {
  group('deepCastMap', () {
    test('converts dynamic keys to strings', () {
      final input = <dynamic, dynamic>{1: 'a', 2: 'b'};
      final result = deepCastMap(input);
      expect(result, {'1': 'a', '2': 'b'});
      expect(result, isA<Map<String, dynamic>>());
    });

    test('recursively converts nested maps', () {
      final input = <dynamic, dynamic>{
        'outer': <dynamic, dynamic>{
          'inner': 42,
        },
      };
      final result = deepCastMap(input);
      expect(result['outer'], isA<Map<String, dynamic>>());
      expect((result['outer'] as Map)['inner'], 42);
    });

    test('converts maps inside lists', () {
      final input = <dynamic, dynamic>{
        'items': [
          <dynamic, dynamic>{'id': 1},
          <dynamic, dynamic>{'id': 2},
        ],
      };
      final result = deepCastMap(input);
      final items = result['items'] as List;
      expect(items[0], isA<Map<String, dynamic>>());
      expect((items[0] as Map)['id'], 1);
    });

    test('preserves primitive values', () {
      final input = <dynamic, dynamic>{
        'str': 'hello',
        'num': 42,
        'dbl': 3.14,
        'bool': true,
        'null': null,
      };
      final result = deepCastMap(input);
      expect(result['str'], 'hello');
      expect(result['num'], 42);
      expect(result['dbl'], 3.14);
      expect(result['bool'], true);
      expect(result['null'], isNull);
    });

    test('handles empty map', () {
      final result = deepCastMap({});
      expect(result, isEmpty);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('handles deeply nested structure', () {
      final input = <dynamic, dynamic>{
        'l1': <dynamic, dynamic>{
          'l2': <dynamic, dynamic>{
            'l3': [
              <dynamic, dynamic>{'value': 'deep'},
            ],
          },
        },
      };
      final result = deepCastMap(input);
      final l1 = result['l1'] as Map<String, dynamic>;
      final l2 = l1['l2'] as Map<String, dynamic>;
      final l3 = l2['l3'] as List;
      expect((l3[0] as Map)['value'], 'deep');
    });
  });
}
