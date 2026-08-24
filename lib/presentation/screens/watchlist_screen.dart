import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_outline, size: 64,
                      color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your watchlist is empty'),
                  SizedBox(height: 8),
                  Text(
                    'Search for movies and TV shows\nand save them here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
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
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  child:
                      const Icon(Icons.delete, color: Colors.white),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
