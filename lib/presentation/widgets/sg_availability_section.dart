import 'package:flutter/material.dart';
import 'package:watchfrom/config/theme.dart';
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDim,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.vpn_lock,
                  color: AppTheme.coral.withValues(alpha: 0.7), size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Not available for streaming in Singapore',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppTheme.dimText,
                  ),
                ),
              ),
            ],
          ),
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
          Text(
            '\u{1F1F8}\u{1F1EC} Singapore',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.dimText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: grouped[type]!
                    .map((p) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDim,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ProviderLogo(logoPath: p.logoPath, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                p.providerName,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
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
