import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 48,
          height: 72,
          child: item.posterPath != null
              ? CachedNetworkImage(
                  imageUrl: TmdbImageUrl.poster(item.posterPath!),
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      const ColoredBox(color: Colors.grey),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.movie_outlined),
                )
              : const ColoredBox(
                  color: Colors.grey,
                  child: Icon(Icons.movie_outlined),
                ),
        ),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.releaseYear != null) ...[
                Text(item.releaseYear!),
                const SizedBox(width: 8),
              ],
              Text(
                item.mediaType == MediaType.movie ? 'Movie' : 'TV',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          if (summary.isNotEmpty)
            Text(
              summary,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      isThreeLine: summary.isNotEmpty,
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
