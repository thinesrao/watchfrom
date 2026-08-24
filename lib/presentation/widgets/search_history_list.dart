import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/models/search_history_entry.dart';
import 'package:watchfrom/presentation/providers/search_history_providers.dart';

class SearchHistoryList extends ConsumerWidget {
  const SearchHistoryList({super.key, required this.onTap});

  final void Function(String query) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(searchHistoryProvider);

    return historyAsync.when(
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent searches',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(searchHistoryProvider.notifier).clearAll(),
                    child: const Text('Clear all'),
                  ),
                ],
              ),
            ),
            ...entries.map((entry) => _HistoryTile(
                  entry: entry,
                  onTap: () => onTap(entry.query),
                  onDelete: () => ref
                      .read(searchHistoryProvider.notifier)
                      .remove(entry.query),
                )),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  final SearchHistoryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history, size: 20),
      title: Text(entry.query),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: onDelete,
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
