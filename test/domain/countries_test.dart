import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/domain/countries.dart';

void main() {
  group('Countries', () {
    test('nameFor returns country name for known code', () {
      expect(Countries.nameFor('SG'), 'Singapore');
      expect(Countries.nameFor('US'), 'United States');
      expect(Countries.nameFor('GB'), 'United Kingdom');
    });

    test('nameFor is case-insensitive', () {
      expect(Countries.nameFor('sg'), 'Singapore');
    });

    test('nameFor returns null for unknown code', () {
      expect(Countries.nameFor('ZZ'), isNull);
    });

    test('flagFor generates correct flag emoji from country code', () {
      expect(Countries.flagFor('SG'), '🇸🇬');
      expect(Countries.flagFor('US'), '🇺🇸');
    });

    test('flagFor is case-insensitive', () {
      expect(Countries.flagFor('sg'), '🇸🇬');
    });
  });
}
