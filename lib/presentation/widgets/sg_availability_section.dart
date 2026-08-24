import 'package:flutter/material.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/presentation/widgets/provider_logo.dart';

class SgAvailabilitySection extends StatelessWidget {
  const SgAvailabilitySection({super.key, this.sgAvailability});

  final CountryAvailability? sgAvailability;

  @override
  Widget build(BuildContext context) {
    final hasFlatrate = sgAvailability != null &&
        sgAvailability!.providers
            .any((p) => p.providerType == ProviderType.flatrate);

    if (!hasFlatrate) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.vpn_lock, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Not available for streaming in Singapore',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    final grouped = <ProviderType, List<WatchProvider>>{};
    for (final p in sgAvailability!.providers) {
      grouped.putIfAbsent(p.providerType, () => []).add(p);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🇸🇬',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 8),
              Text(
                'Available in Singapore',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final type in [
            ProviderType.flatrate,
            ProviderType.rent,
            ProviderType.buy,
          ])
            if (grouped.containsKey(type)) ...[
              Text(
                _typeLabel(type),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: grouped[type]!
                    .map((p) => Chip(
                          avatar: ProviderLogo(
                              logoPath: p.logoPath, size: 24),
                          label: Text(p.providerName),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  String _typeLabel(ProviderType type) {
    switch (type) {
      case ProviderType.flatrate:
        return 'Stream';
      case ProviderType.rent:
        return 'Rent';
      case ProviderType.buy:
        return 'Buy';
    }
  }
}
