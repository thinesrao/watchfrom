import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/presentation/providers/search_history_providers.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/widgets/search_history_list.dart';
import 'package:watchfrom/presentation/widgets/search_result_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  bool _showHistory = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _showHistory = _focusNode.hasFocus &&
          _controller.text.isEmpty);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() => _showHistory = value.isEmpty && _focusNode.hasFocus);

    if (value.trim().isEmpty) {
      ref.read(searchQueryProvider.notifier).state = '';
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = value;
      ref.read(searchHistoryProvider.notifier).add(value);
    });
  }

  void _runSearch(String query) {
    _controller.text = query;
    _focusNode.unfocus();
    setState(() => _showHistory = false);
    ref.read(searchQueryProvider.notifier).state = query;
    ref.read(searchHistoryProvider.notifier).add(query);
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('WatchFrom')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search movies and TV shows',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _showHistory && query.isEmpty
                ? SearchHistoryList(onTap: _runSearch)
                : _buildResults(resultsAsync, query),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(
    AsyncValue<List<SearchResult>> resultsAsync,
    String query,
  ) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Search movies and TV shows'),
      );
    }

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return const Center(
            child: Text('No movies or TV shows found'),
          );
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return SearchResultCard(
              result: result,
              onTap: () => context.push('/detail', extra: {
                'searchResult': result,
              }),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.invalidate(searchResultsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
