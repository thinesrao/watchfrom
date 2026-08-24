import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watchfrom/config/theme.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/domain/availability_diff.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/utils/error_messages.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildPosterHero(),
            ),
          ),
          SliverToBoxAdapter(
            child: availabilityAsync.when(
              data: (availability) =>
                  _buildContent(context, ref, availability),
              loading: () => const Padding(
                padding: EdgeInsets.all(64),
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.coral),
                ),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      friendlyError(error),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          ref.invalidate(watchProvidersProvider(params)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterHero() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (searchResult.posterPath != null)
          CachedNetworkImage(
            imageUrl: TmdbImageUrl.posterLarge(searchResult.posterPath!),
            fit: BoxFit.cover,
          )
        else
          const ColoredBox(color: AppTheme.surface),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87, Colors.black],
              stops: [0.3, 0.75, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<CountryAvailability> availability,
  ) {
    final sg = availability.where((a) => a.countryCode == 'SG').firstOrNull;
    final worldwide =
        availability.where((a) => a.countryCode != 'SG').toList();
    final hasChanged = savedSnapshot != null &&
        availabilityChanged(availability, savedSnapshot!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            searchResult.title,
            style: GoogleFonts.dmSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              if (searchResult.releaseYear != null) ...[
                Text(
                  searchResult.releaseYear!,
                  style: const TextStyle(
                    color: AppTheme.dimText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.coral.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  searchResult.mediaType == MediaType.movie ? 'Movie' : 'TV',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.coral,
                  ),
                ),
              ),
              if (searchResult.voteAverage != null) ...[
                const SizedBox(width: 10),
                const Icon(Icons.star, size: 14, color: AppTheme.gold),
                const SizedBox(width: 3),
                Text(
                  searchResult.voteAverage!.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.dimText,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (searchResult.overview != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              searchResult.overview!,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.dimText,
                height: 1.6,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (hasChanged)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              color: AppTheme.coral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.coral.withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.coral, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Availability has changed since you saved this',
                    style: TextStyle(fontSize: 13, color: AppTheme.coral),
                  ),
                ),
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
        const SizedBox(height: 40),
      ],
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
          child: SizedBox(
            width: double.infinity,
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
                isInWatchlist
                    ? 'Remove from Watchlist'
                    : 'Save to Watchlist',
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
