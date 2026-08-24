import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchfrom/config/theme.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final WatchlistItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final summary = _buildSummary();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 72,
                child: item.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: TmdbImageUrl.poster(item.posterPath!),
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const ColoredBox(color: AppTheme.surfaceDim),
                        errorWidget: (_, __, ___) => const ColoredBox(
                          color: AppTheme.surfaceDim,
                          child: Icon(Icons.movie_outlined, size: 20,
                              color: AppTheme.dimText),
                        ),
                      )
                    : const ColoredBox(
                        color: AppTheme.surfaceDim,
                        child: Icon(Icons.movie_outlined, size: 20,
                            color: AppTheme.dimText),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.releaseYear != null) ...[
                        Text(
                          item.releaseYear!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.dimText,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.coral.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          item.mediaType == MediaType.movie ? 'Movie' : 'TV',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.coral,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (summary.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      summary,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.dimText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.dimText, size: 20),
          ],
        ),
      ),
    );
  }

  String _buildSummary() {
    final providerCountries = <String, List<String>>{};
    for (final entry in item.availabilitySnapshot.entries) {
      for (final p in entry.value) {
        if (p.providerType == ProviderType.flatrate) {
          providerCountries
              .putIfAbsent(p.providerName, () => [])
              .add(entry.key);
        }
      }
    }
    if (providerCountries.isEmpty) return '';

    final sorted = providerCountries.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    final top = sorted.first;
    final countryCodes = top.value.take(3).join(', ');
    final remaining = top.value.length - 3;

    if (remaining > 0) {
      return '${top.key}: $countryCodes +$remaining more';
    }
    return '${top.key}: $countryCodes';
  }
}
