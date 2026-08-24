import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/screens/search_screen.dart';

void main() {
  group('SearchScreen', () {
    testWidgets('shows empty state when no query', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SearchScreen()),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search movies and TV shows'), findsOneWidget);
    });

    testWidgets('shows search results', (tester) async {
      final results = [
        const SearchResult(
          id: 1,
          title: 'Inception',
          mediaType: MediaType.movie,
          releaseYear: '2010',
          voteAverage: 8.4,
        ),
        const SearchResult(
          id: 2,
          title: 'Breaking Bad',
          mediaType: MediaType.tv,
          releaseYear: '2008',
          voteAverage: 8.9,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchResultsProvider
                .overrideWith((ref) => Future.value(results)),
            searchQueryProvider.overrideWith((ref) => 'inception'),
          ],
          child: const MaterialApp(home: SearchScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inception'), findsOneWidget);
      expect(find.text('Breaking Bad'), findsOneWidget);
      expect(find.text('Movie'), findsOneWidget);
      expect(find.text('TV'), findsOneWidget);
    });

    testWidgets('shows no results message', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchResultsProvider
                .overrideWith((ref) => Future.value(<SearchResult>[])),
            searchQueryProvider.overrideWith((ref) => 'xyznonexistent'),
          ],
          child: const MaterialApp(home: SearchScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No movies or TV shows found'), findsOneWidget);
    });
  });
}
