import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

part 'country_availability.freezed.dart';
part 'country_availability.g.dart';

@freezed
abstract class CountryAvailability with _$CountryAvailability {
  const factory CountryAvailability({
    required String countryCode,
    required String countryName,
    required String flagEmoji,
    required List<WatchProvider> providers,
  }) = _CountryAvailability;

  factory CountryAvailability.fromJson(Map<String, dynamic> json) =>
      _$CountryAvailabilityFromJson(json);
}
