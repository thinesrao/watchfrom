import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/domain/availability_diff.dart';

const _netflix = WatchProvider(
  providerId: 8,
  providerName: 'Netflix',
  logoPath: '/netflix.jpg',
  providerType: ProviderType.flatrate,
);

const _disney = WatchProvider(
  providerId: 337,
  providerName: 'Disney Plus',
  logoPath: '/disney.jpg',
  providerType: ProviderType.flatrate,
);

const _hbo = WatchProvider(
  providerId: 384,
  providerName: 'HBO Max',
  logoPath: '/hbo.jpg',
  providerType: ProviderType.flatrate,
);

const _rentProvider = WatchProvider(
  providerId: 2,
  providerName: 'Apple TV',
  logoPath: '/apple.jpg',
  providerType: ProviderType.rent,
);

void main() {
  group('availabilityChanged', () {
    test('returns false when live matches snapshot exactly', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_netflix],
        ),
      ];
      final snapshot = {
        'US': [_netflix],
      };
      expect(availabilityChanged(live, snapshot), isFalse);
    });

    test('returns true when a country is added', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_netflix],
        ),
        const CountryAvailability(
          countryCode: 'GB',
          countryName: 'United Kingdom',
          flagEmoji: '🇬🇧',
          providers: [_netflix],
        ),
      ];
      final snapshot = {
        'US': [_netflix],
      };
      expect(availabilityChanged(live, snapshot), isTrue);
    });

    test('returns true when a country is removed', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_netflix],
        ),
      ];
      final snapshot = {
        'US': [_netflix],
        'GB': [_netflix],
      };
      expect(availabilityChanged(live, snapshot), isTrue);
    });

    test('returns true when a provider is added in a country', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_netflix, _disney],
        ),
      ];
      final snapshot = {
        'US': [_netflix],
      };
      expect(availabilityChanged(live, snapshot), isTrue);
    });

    test('returns true when a provider is removed from a country', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_netflix],
        ),
      ];
      final snapshot = {
        'US': [_netflix, _disney],
      };
      expect(availabilityChanged(live, snapshot), isTrue);
    });

    test('returns true when provider swapped in a country', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_hbo],
        ),
      ];
      final snapshot = {
        'US': [_netflix],
      };
      expect(availabilityChanged(live, snapshot), isTrue);
    });

    test('ignores non-flatrate providers when comparing', () {
      final live = [
        const CountryAvailability(
          countryCode: 'US',
          countryName: 'United States',
          flagEmoji: '🇺🇸',
          providers: [_netflix, _rentProvider],
        ),
      ];
      final snapshot = {
        'US': [_netflix],
      };
      expect(availabilityChanged(live, snapshot), isFalse);
    });

    test('returns false for empty live and empty snapshot', () {
      expect(availabilityChanged([], {}), isFalse);
    });

    test('returns true for empty live vs non-empty snapshot', () {
      final snapshot = {
        'US': [_netflix],
      };
      expect(availabilityChanged([], snapshot), isTrue);
    });
  });
}
