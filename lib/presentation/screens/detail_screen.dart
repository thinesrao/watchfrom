import 'package:flutter/material.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

// TODO(task-7): replace this stub with the full detail screen implementation
// that actually renders the `savedSnapshot` passed by the router.
class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.searchResult,
    this.savedSnapshot,
  });

  final SearchResult searchResult;
  final Map<String, List<WatchProvider>>? savedSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(searchResult.title)),
      body: const Center(child: Text('Detail coming soon')),
    );
  }
}
