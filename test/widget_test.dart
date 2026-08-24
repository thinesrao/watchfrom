// Basic smoke test for the WatchFrom app shell: verifies the bottom
// navigation renders with both tabs and that tapping a destination
// switches the selected tab.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchfrom/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen shows two-tab navigation and switches tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    // Both destinations are present in the bottom navigation bar.
    final navBarFinder = find.byType(NavigationBar);
    expect(
      find.descendant(of: navBarFinder, matching: find.byIcon(Icons.search)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: navBarFinder,
        matching: find.byIcon(Icons.bookmark_outline),
      ),
      findsOneWidget,
    );

    // Search tab is selected by default.
    NavigationBar navBar = tester.widget(navBarFinder);
    expect(navBar.selectedIndex, 0);

    // Tap the Watchlist destination icon.
    await tester.tap(
      find.descendant(
        of: navBarFinder,
        matching: find.byIcon(Icons.bookmark_outline),
      ),
    );
    await tester.pumpAndSettle();

    navBar = tester.widget(navBarFinder);
    expect(navBar.selectedIndex, 1);
  });
}
