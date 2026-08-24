import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

bool availabilityChanged(
  List<CountryAvailability> live,
  Map<String, List<WatchProvider>> snapshot,
) {
  final liveMap = <String, Set<int>>{};
  for (final country in live) {
    liveMap[country.countryCode] = country.providers
        .where((p) => p.providerType == ProviderType.flatrate)
        .map((p) => p.providerId)
        .toSet();
  }
  final snapshotMap = <String, Set<int>>{};
  for (final entry in snapshot.entries) {
    snapshotMap[entry.key] = entry.value
        .where((p) => p.providerType == ProviderType.flatrate)
        .map((p) => p.providerId)
        .toSet();
  }
  if (liveMap.keys.length != snapshotMap.keys.length) return true;
  for (final code in liveMap.keys) {
    if (!snapshotMap.containsKey(code)) return true;
    if (!liveMap[code]!.containsAll(snapshotMap[code]!) ||
        !snapshotMap[code]!.containsAll(liveMap[code]!)) {
      return true;
    }
  }
  return false;
}
