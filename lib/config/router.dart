import 'package:go_router/go_router.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/presentation/screens/detail_screen.dart';
import 'package:watchfrom/presentation/screens/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detail',
      redirect: (context, state) {
        if (state.extra == null || state.extra is! Map<String, dynamic>) {
          return '/';
        }
        final extra = state.extra! as Map<String, dynamic>;
        if (extra['searchResult'] is! SearchResult) return '/';
        return null;
      },
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        final result = extra['searchResult'] as SearchResult;
        final snapshot =
            extra['snapshot'] as Map<String, List<WatchProvider>>?;
        return DetailScreen(searchResult: result, savedSnapshot: snapshot);
      },
    ),
  ],
);
