import 'package:flutter/material.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/presentation/widgets/provider_logo.dart';

class WorldwideAvailabilitySection extends StatelessWidget {
  const WorldwideAvailabilitySection({
    super.key,
    required this.availability,
  });

  final List<CountryAvailability> availability;

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByProvider(availability);

    if (grouped.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No streaming availability data found'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available worldwide via VPN',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...grouped.map((entry) => _ProviderRow(entry: entry)),
        ],
      ),
    );
  }

  List<_ProviderCountries> _groupByProvider(
    List<CountryAvailability> availability,
  ) {
    final map = <int, _ProviderCountries>{};
    for (final country in availability) {
      for (final provider in country.providers
          .where((p) => p.providerType == ProviderType.flatrate)) {
        map
            .putIfAbsent(
              provider.providerId,
              () => _ProviderCountries(provider: provider, countries: []),
            )
            .countries
            .add(_CountryInfo(
              code: country.countryCode,
              name: country.countryName,
              flag: country.flagEmoji,
            ));
      }
    }
    final result = map.values.toList()
      ..sort((a, b) => b.countries.length.compareTo(a.countries.length));
    return result;
  }
}

class _ProviderCountries {
  _ProviderCountries({required this.provider, required this.countries});
  final WatchProvider provider;
  final List<_CountryInfo> countries;
}

class _CountryInfo {
  _CountryInfo({
    required this.code,
    required this.name,
    required this.flag,
  });
  final String code;
  final String name;
  final String flag;
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({required this.entry});

  final _ProviderCountries entry;

  @override
  Widget build(BuildContext context) {
    final displayCountries = entry.countries.take(5).toList();
    final remaining = entry.countries.length - displayCountries.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProviderLogo(logoPath: entry.provider.logoPath),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.provider.providerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    ...displayCountries.map((c) => Text(
                          '${c.flag} ${c.name}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                    if (remaining > 0)
                      Text(
                        '+$remaining more',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
