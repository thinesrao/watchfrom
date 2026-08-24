import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';
import 'package:watchfrom/data/models/search_result.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final SearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 48,
          height: 72,
          child: result.posterPath != null
              ? CachedNetworkImage(
                  imageUrl: TmdbImageUrl.poster(result.posterPath!),
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
        result.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          if (result.releaseYear != null) ...[
            Text(result.releaseYear!),
            const SizedBox(width: 8),
          ],
          if (result.voteAverage != null) ...[
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 2),
            Text(result.voteAverage!.toStringAsFixed(1)),
          ],
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: result.mediaType == MediaType.movie
              ? Colors.blue.withValues(alpha: 0.2)
              : Colors.purple.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          result.mediaType == MediaType.movie ? 'Movie' : 'TV',
          style: TextStyle(
            fontSize: 12,
            color: result.mediaType == MediaType.movie
                ? Colors.blue
                : Colors.purple,
          ),
        ),
      ),
    );
  }
}
