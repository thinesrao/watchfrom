import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watchfrom/config/theme.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/widgets/watchlist_card.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistAsync = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: watchlistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_outline, size: 56,
                      color: AppTheme.dimText.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Your watchlist is empty',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Search for movies and TV shows\nand save them here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.dimText,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.tmdbId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppTheme.coral,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(watchlistProvider.notifier)
                      .remove(item.tmdbId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} removed'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => ref
                            .read(watchlistProvider.notifier)
                            .add(item),
                      ),
                    ),
                  );
                },
                child: WatchlistCard(
                  item: item,
                  onTap: () {
                    final searchResult = SearchResult(
                      id: item.tmdbId,
                      title: item.title,
                      mediaType: item.mediaType,
                      posterPath: item.posterPath,
                      releaseYear: item.releaseYear,
                    );
                    context.push('/detail', extra: {
                      'searchResult': searchResult,
                      'snapshot': item.availabilitySnapshot,
                    });
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.coral),
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
