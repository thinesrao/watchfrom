import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/widgets/sg_availability_section.dart';
import 'package:watchfrom/presentation/widgets/worldwide_availability_section.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({
    super.key,
    required this.searchResult,
    this.savedSnapshot,
  });

  final SearchResult searchResult;
  final Map<String, List<WatchProvider>>? savedSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (id: searchResult.id, mediaType: searchResult.mediaType);
    final availabilityAsync = ref.watch(watchProvidersProvider(params));

    return Scaffold(
      appBar: AppBar(title: Text(searchResult.title)),
      body: availabilityAsync.when(
        data: (availability) => _buildContent(context, ref, availability),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(watchProvidersProvider(params)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<CountryAvailability> availability,
  ) {
    final sg =
        availability.where((a) => a.countryCode == 'SG').firstOrNull;
    final worldwide =
        availability.where((a) => a.countryCode != 'SG').toList();
    final hasChanged = savedSnapshot != null &&
        _availabilityChanged(availability, savedSnapshot!);

    return ListView(
      children: [
        _buildHeader(context),
        if (hasChanged)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Text('Availability has changed since you saved this'),
              ],
            ),
          ),
        const Divider(),
        SgAvailabilitySection(sgAvailability: sg),
        if (worldwide.isNotEmpty) ...[
          const Divider(),
          WorldwideAvailabilitySection(availability: worldwide),
        ],
        const SizedBox(height: 24),
        _buildWatchlistButton(context, ref, availability),
        const SizedBox(height: 32),
      ],
    );
  }

  bool _availabilityChanged(
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchResult.posterPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    TmdbImageUrl.posterLarge(searchResult.posterPath!),
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  searchResult.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (searchResult.releaseYear != null)
                      Text(searchResult.releaseYear!),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        searchResult.mediaType == MediaType.movie
                            ? 'Movie'
                            : 'TV',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    if (searchResult.voteAverage != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.star,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(searchResult.voteAverage!
                          .toStringAsFixed(1)),
                    ],
                  ],
                ),
                if (searchResult.overview != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    searchResult.overview!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistButton(
    BuildContext context,
    WidgetRef ref,
    List<CountryAvailability> availability,
  ) {
    final watchlistAsync = ref.watch(watchlistProvider);

    return watchlistAsync.when(
      data: (items) {
        final isInWatchlist =
            items.any((item) => item.tmdbId == searchResult.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.icon(
            onPressed: () {
              if (isInWatchlist) {
                ref
                    .read(watchlistProvider.notifier)
                    .remove(searchResult.id);
              } else {
                final snapshot = <String, List<WatchProvider>>{};
                for (final country in availability) {
                  snapshot[country.countryCode] = country.providers;
                }
                ref.read(watchlistProvider.notifier).add(WatchlistItem(
                      tmdbId: searchResult.id,
                      title: searchResult.title,
                      mediaType: searchResult.mediaType,
                      posterPath: searchResult.posterPath,
                      releaseYear: searchResult.releaseYear,
                      savedAt: DateTime.now(),
                      availabilitySnapshot: snapshot,
                    ));
              }
            },
            icon: Icon(
                isInWatchlist ? Icons.bookmark : Icons.bookmark_outline),
            label: Text(
              isInWatchlist ? 'Remove from Watchlist' : 'Save to Watchlist',
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
