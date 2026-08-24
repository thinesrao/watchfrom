import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchfrom/config/theme.dart';
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
                child: result.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: TmdbImageUrl.poster(result.posterPath!),
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
                    result.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (result.releaseYear != null) ...[
                        Text(
                          result.releaseYear!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.dimText,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (result.voteAverage != null) ...[
                        const Icon(Icons.star, size: 13,
                            color: AppTheme.gold),
                        const SizedBox(width: 3),
                        Text(
                          result.voteAverage!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.dimText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.coral.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                result.mediaType == MediaType.movie ? 'Movie' : 'TV',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.coral,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
