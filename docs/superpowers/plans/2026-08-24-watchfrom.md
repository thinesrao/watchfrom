# WatchFrom Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a personal Flutter mobile app that searches movies/TV shows via TMDB and shows streaming availability by country — Singapore first, then worldwide — so you know which VPN server to connect to.

**Architecture:** Three-layer Flutter app (data → domain → presentation). TMDB REST API for search and streaming provider data. Hive CE for local persistence (watchlist + search history). Riverpod for reactive state management with AsyncNotifier pattern. Two-tab navigation (Search + Watchlist) with a push detail screen.

**Tech Stack:** Flutter, Dart, flutter_riverpod, dio, go_router, freezed + json_serializable, hive_ce + hive_ce_flutter, cached_network_image, flutter_dotenv, mocktail

**Spec:** `docs/superpowers/specs/2026-08-24-watchfrom-design.md`

## Global Constraints

- Flutter latest stable, targeting iOS + Android
- TMDB API v3 — base URL: `https://api.themoviedb.org/3`
- Auth: Bearer token via `TMDB_API_READ_ACCESS_TOKEN` from `.env.local`
- Image base: `https://image.tmdb.org/t/p/{size}{path}`
- Home country: Singapore (`SG`)
- Personal use — no backend, no auth, no analytics
- Deviation from spec: Hive CE replaces Isar (Isar unmaintained since 2023)

---

### Task 1: Project Scaffolding & App Shell

**Files:**
- Create: `pubspec.yaml` (via flutter create + pub add), `lib/main.dart`, `lib/app.dart`, `lib/config/theme.dart`, `lib/config/router.dart`, `lib/presentation/screens/home_screen.dart`, `lib/presentation/screens/search_screen.dart`, `lib/presentation/screens/watchlist_screen.dart`, `.env`
- Modify: `.gitignore`

**Interfaces:**
- Consumes: nothing (first task)
- Produces: Running Flutter app with two-tab bottom navigation (Search + Watchlist) showing placeholder screens. `GoRouter` configured at `/` (home) with a `/detail` route stub.

- [ ] **Step 1: Create Flutter project**

```bash
cd /Users/thinesraoraman/Projects/watchfrom
flutter create --org com.watchfrom --platforms ios,android .
```

This adds Flutter structure around existing files (docs/, .env.local, .git/).

- [ ] **Step 2: Add dependencies**

```bash
flutter pub add flutter_riverpod dio go_router cached_network_image freezed_annotation json_annotation hive_ce hive_ce_flutter flutter_dotenv
flutter pub add --dev build_runner freezed json_serializable mocktail
```

- [ ] **Step 3: Configure .env and .gitignore**

Copy the TMDB keys into a `.env` file that flutter_dotenv will bundle:

```bash
cp .env.local .env
```

Add to `.gitignore` (append after the flutter-generated entries):

```
# Environment
.env
.env.local
```

Add `.env` to `pubspec.yaml` assets. Find the `flutter:` section and add:

```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
```

- [ ] **Step 4: Write `lib/config/theme.dart`**

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF6366F1),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Write `lib/config/router.dart`**

```dart
import 'package:go_router/go_router.dart';
import 'package:watchfrom/presentation/screens/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
```

- [ ] **Step 6: Write placeholder `lib/presentation/screens/search_screen.dart`**

```dart
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search'));
  }
}
```

- [ ] **Step 7: Write placeholder `lib/presentation/screens/watchlist_screen.dart`**

```dart
import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Watchlist'));
  }
}
```

- [ ] **Step 8: Write `lib/presentation/screens/home_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:watchfrom/presentation/screens/search_screen.dart';
import 'package:watchfrom/presentation/screens/watchlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _screens = [
    SearchScreen(),
    WatchlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 9: Write `lib/app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:watchfrom/config/router.dart';
import 'package:watchfrom/config/theme.dart';

class WatchFromApp extends StatelessWidget {
  const WatchFromApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WatchFrom',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

- [ ] **Step 10: Write `lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:watchfrom/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  runApp(const ProviderScope(child: WatchFromApp()));
}
```

- [ ] **Step 11: Run the app to verify**

```bash
flutter run
```

Expected: app launches with dark theme, two-tab navigation bar (Search + Watchlist), each tab shows placeholder text.

- [ ] **Step 12: Commit**

```bash
git add -A
git commit -m "feat: scaffold Flutter project with two-tab navigation shell"
```

---

### Task 2: Data Models & Country Map

**Files:**
- Create: `lib/data/models/search_result.dart`, `lib/data/models/watch_provider.dart`, `lib/data/models/country_availability.dart`, `lib/data/models/watchlist_item.dart`, `lib/data/models/search_history_entry.dart`, `lib/domain/countries.dart`
- Test: `test/data/models/search_result_test.dart`, `test/data/models/watchlist_item_test.dart`, `test/domain/countries_test.dart`

**Interfaces:**
- Consumes: nothing
- Produces:
  - `SearchResult({int id, String title, MediaType mediaType, String? posterPath, String? releaseYear, String? overview, double? voteAverage})` + `SearchResult.fromTmdb(Map<String, dynamic>)`
  - `WatchProvider({int providerId, String providerName, String logoPath, ProviderType providerType})` + `WatchProvider.fromTmdb(Map<String, dynamic>, ProviderType)`
  - `CountryAvailability({String countryCode, String countryName, String flagEmoji, List<WatchProvider> providers})`
  - `WatchlistItem({int tmdbId, String title, MediaType mediaType, String? posterPath, String? releaseYear, DateTime savedAt, Map<String, List<WatchProvider>> availabilitySnapshot})`
  - `SearchHistoryEntry({String query, DateTime searchedAt})`
  - `enum MediaType { movie, tv }`
  - `enum ProviderType { flatrate, rent, buy }`
  - `Countries.nameFor(String code) → String?`
  - `Countries.flagFor(String code) → String`

- [ ] **Step 1: Write failing test for SearchResult.fromTmdb**

Create `test/data/models/search_result_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';

void main() {
  group('SearchResult', () {
    test('fromTmdb parses a movie correctly', () {
      final json = {
        'id': 27205,
        'media_type': 'movie',
        'title': 'Inception',
        'release_date': '2010-07-16',
        'poster_path': '/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg',
        'overview': 'A thief who steals secrets...',
        'vote_average': 8.369,
      };

      final result = SearchResult.fromTmdb(json);

      expect(result.id, 27205);
      expect(result.title, 'Inception');
      expect(result.mediaType, MediaType.movie);
      expect(result.releaseYear, '2010');
      expect(result.posterPath, '/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg');
      expect(result.overview, 'A thief who steals secrets...');
      expect(result.voteAverage, 8.369);
    });

    test('fromTmdb parses a TV show correctly', () {
      final json = {
        'id': 1396,
        'media_type': 'tv',
        'name': 'Breaking Bad',
        'first_air_date': '2008-01-20',
        'poster_path': '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
        'overview': 'A chemistry teacher...',
        'vote_average': 8.912,
      };

      final result = SearchResult.fromTmdb(json);

      expect(result.id, 1396);
      expect(result.title, 'Breaking Bad');
      expect(result.mediaType, MediaType.tv);
      expect(result.releaseYear, '2008');
    });

    test('fromTmdb handles missing optional fields', () {
      final json = {
        'id': 999,
        'media_type': 'movie',
        'title': 'Unknown Movie',
      };

      final result = SearchResult.fromTmdb(json);

      expect(result.id, 999);
      expect(result.title, 'Unknown Movie');
      expect(result.posterPath, isNull);
      expect(result.releaseYear, isNull);
      expect(result.overview, isNull);
      expect(result.voteAverage, isNull);
    });

    test('toJson and fromJson round-trip', () {
      final original = SearchResult(
        id: 1,
        title: 'Test',
        mediaType: MediaType.movie,
        posterPath: '/test.jpg',
        releaseYear: '2024',
        overview: 'A test movie',
        voteAverage: 7.5,
      );

      final json = original.toJson();
      final restored = SearchResult.fromJson(json);

      expect(restored, original);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/data/models/search_result_test.dart
```

Expected: FAIL — `search_result.dart` doesn't exist.

- [ ] **Step 3: Create `lib/data/models/search_result.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

enum MediaType { movie, tv }

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required int id,
    required String title,
    required MediaType mediaType,
    String? posterPath,
    String? releaseYear,
    String? overview,
    double? voteAverage,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  factory SearchResult.fromTmdb(Map<String, dynamic> json) {
    final isMovie = json['media_type'] == 'movie';
    final title = isMovie
        ? json['title'] as String? ?? ''
        : json['name'] as String? ?? '';
    final dateStr = isMovie
        ? json['release_date'] as String?
        : json['first_air_date'] as String?;

    return SearchResult(
      id: json['id'] as int,
      title: title,
      mediaType: isMovie ? MediaType.movie : MediaType.tv,
      posterPath: json['poster_path'] as String?,
      releaseYear: dateStr != null && dateStr.length >= 4
          ? dateStr.substring(0, 4)
          : null,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }
}
```

- [ ] **Step 4: Create `lib/data/models/watch_provider.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watch_provider.freezed.dart';
part 'watch_provider.g.dart';

enum ProviderType { flatrate, rent, buy }

@freezed
class WatchProvider with _$WatchProvider {
  const factory WatchProvider({
    required int providerId,
    required String providerName,
    required String logoPath,
    required ProviderType providerType,
  }) = _WatchProvider;

  factory WatchProvider.fromJson(Map<String, dynamic> json) =>
      _$WatchProviderFromJson(json);

  factory WatchProvider.fromTmdb(
      Map<String, dynamic> json, ProviderType type) {
    return WatchProvider(
      providerId: json['provider_id'] as int,
      providerName: json['provider_name'] as String,
      logoPath: json['logo_path'] as String,
      providerType: type,
    );
  }
}
```

- [ ] **Step 5: Create `lib/data/models/country_availability.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

part 'country_availability.freezed.dart';
part 'country_availability.g.dart';

@freezed
class CountryAvailability with _$CountryAvailability {
  const factory CountryAvailability({
    required String countryCode,
    required String countryName,
    required String flagEmoji,
    required List<WatchProvider> providers,
  }) = _CountryAvailability;

  factory CountryAvailability.fromJson(Map<String, dynamic> json) =>
      _$CountryAvailabilityFromJson(json);
}
```

- [ ] **Step 6: Create `lib/data/models/watchlist_item.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

part 'watchlist_item.freezed.dart';
part 'watchlist_item.g.dart';

@freezed
class WatchlistItem with _$WatchlistItem {
  const factory WatchlistItem({
    required int tmdbId,
    required String title,
    required MediaType mediaType,
    String? posterPath,
    String? releaseYear,
    required DateTime savedAt,
    required Map<String, List<WatchProvider>> availabilitySnapshot,
  }) = _WatchlistItem;

  factory WatchlistItem.fromJson(Map<String, dynamic> json) =>
      _$WatchlistItemFromJson(json);
}
```

- [ ] **Step 7: Create `lib/data/models/search_history_entry.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history_entry.freezed.dart';
part 'search_history_entry.g.dart';

@freezed
class SearchHistoryEntry with _$SearchHistoryEntry {
  const factory SearchHistoryEntry({
    required String query,
    required DateTime searchedAt,
  }) = _SearchHistoryEntry;

  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryEntryFromJson(json);
}
```

- [ ] **Step 8: Run build_runner to generate code**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: generates `.freezed.dart` and `.g.dart` files for all models.

- [ ] **Step 9: Run SearchResult tests to verify they pass**

```bash
flutter test test/data/models/search_result_test.dart
```

Expected: all 4 tests PASS.

- [ ] **Step 10: Write failing test for WatchlistItem serialization**

Create `test/data/models/watchlist_item_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';

void main() {
  group('WatchlistItem', () {
    test('toJson and fromJson round-trip preserves availability snapshot', () {
      final item = WatchlistItem(
        tmdbId: 27205,
        title: 'Inception',
        mediaType: MediaType.movie,
        posterPath: '/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg',
        releaseYear: '2010',
        savedAt: DateTime.utc(2026, 8, 24, 12, 0),
        availabilitySnapshot: {
          'US': [
            const WatchProvider(
              providerId: 8,
              providerName: 'Netflix',
              logoPath: '/t2yyOv40.jpg',
              providerType: ProviderType.flatrate,
            ),
          ],
          'GB': [
            const WatchProvider(
              providerId: 337,
              providerName: 'Disney Plus',
              logoPath: '/7rwgEs15.jpg',
              providerType: ProviderType.flatrate,
            ),
          ],
        },
      );

      final json = item.toJson();
      final restored = WatchlistItem.fromJson(json);

      expect(restored.tmdbId, 27205);
      expect(restored.title, 'Inception');
      expect(restored.availabilitySnapshot.keys, containsAll(['US', 'GB']));
      expect(
        restored.availabilitySnapshot['US']!.first.providerName,
        'Netflix',
      );
    });
  });
}
```

- [ ] **Step 11: Run WatchlistItem test**

```bash
flutter test test/data/models/watchlist_item_test.dart
```

Expected: PASS (code was already generated in step 8).

- [ ] **Step 12: Write failing test for Countries**

Create `test/domain/countries_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/domain/countries.dart';

void main() {
  group('Countries', () {
    test('nameFor returns country name for known code', () {
      expect(Countries.nameFor('SG'), 'Singapore');
      expect(Countries.nameFor('US'), 'United States');
      expect(Countries.nameFor('GB'), 'United Kingdom');
    });

    test('nameFor is case-insensitive', () {
      expect(Countries.nameFor('sg'), 'Singapore');
    });

    test('nameFor returns null for unknown code', () {
      expect(Countries.nameFor('ZZ'), isNull);
    });

    test('flagFor generates correct flag emoji from country code', () {
      expect(Countries.flagFor('SG'), '🇸🇬');
      expect(Countries.flagFor('US'), '🇺🇸');
    });

    test('flagFor is case-insensitive', () {
      expect(Countries.flagFor('sg'), '🇸🇬');
    });
  });
}
```

- [ ] **Step 13: Run test to verify it fails**

```bash
flutter test test/domain/countries_test.dart
```

Expected: FAIL — `countries.dart` doesn't exist.

- [ ] **Step 14: Create `lib/domain/countries.dart`**

```dart
class Countries {
  Countries._();

  static String? nameFor(String code) => _names[code.toUpperCase()];

  static String flagFor(String code) {
    return code
        .toUpperCase()
        .codeUnits
        .map((c) => String.fromCharCode(c + 0x1F1A5))
        .join();
  }

  static const _names = {
    'AD': 'Andorra',
    'AE': 'United Arab Emirates',
    'AG': 'Antigua and Barbuda',
    'AL': 'Albania',
    'AO': 'Angola',
    'AR': 'Argentina',
    'AT': 'Austria',
    'AU': 'Australia',
    'BA': 'Bosnia and Herzegovina',
    'BB': 'Barbados',
    'BE': 'Belgium',
    'BG': 'Bulgaria',
    'BH': 'Bahrain',
    'BO': 'Bolivia',
    'BR': 'Brazil',
    'BS': 'Bahamas',
    'CA': 'Canada',
    'CH': 'Switzerland',
    'CI': "Côte d'Ivoire",
    'CL': 'Chile',
    'CM': 'Cameroon',
    'CO': 'Colombia',
    'CR': 'Costa Rica',
    'CU': 'Cuba',
    'CV': 'Cape Verde',
    'CY': 'Cyprus',
    'CZ': 'Czech Republic',
    'DE': 'Germany',
    'DK': 'Denmark',
    'DO': 'Dominican Republic',
    'DZ': 'Algeria',
    'EC': 'Ecuador',
    'EE': 'Estonia',
    'EG': 'Egypt',
    'ES': 'Spain',
    'FI': 'Finland',
    'FJ': 'Fiji',
    'FR': 'France',
    'GB': 'United Kingdom',
    'GF': 'French Guiana',
    'GH': 'Ghana',
    'GI': 'Gibraltar',
    'GQ': 'Equatorial Guinea',
    'GR': 'Greece',
    'GT': 'Guatemala',
    'GY': 'Guyana',
    'HK': 'Hong Kong',
    'HN': 'Honduras',
    'HR': 'Croatia',
    'HU': 'Hungary',
    'ID': 'Indonesia',
    'IE': 'Ireland',
    'IL': 'Israel',
    'IN': 'India',
    'IQ': 'Iraq',
    'IS': 'Iceland',
    'IT': 'Italy',
    'JM': 'Jamaica',
    'JO': 'Jordan',
    'JP': 'Japan',
    'KE': 'Kenya',
    'KR': 'South Korea',
    'KW': 'Kuwait',
    'LB': 'Lebanon',
    'LC': 'Saint Lucia',
    'LI': 'Liechtenstein',
    'LT': 'Lithuania',
    'LV': 'Latvia',
    'LY': 'Libya',
    'MA': 'Morocco',
    'MC': 'Monaco',
    'MD': 'Moldova',
    'ME': 'Montenegro',
    'MG': 'Madagascar',
    'MK': 'North Macedonia',
    'ML': 'Mali',
    'MT': 'Malta',
    'MU': 'Mauritius',
    'MW': 'Malawi',
    'MX': 'Mexico',
    'MY': 'Malaysia',
    'MZ': 'Mozambique',
    'NE': 'Niger',
    'NG': 'Nigeria',
    'NI': 'Nicaragua',
    'NL': 'Netherlands',
    'NO': 'Norway',
    'NZ': 'New Zealand',
    'OM': 'Oman',
    'PA': 'Panama',
    'PE': 'Peru',
    'PF': 'French Polynesia',
    'PH': 'Philippines',
    'PK': 'Pakistan',
    'PL': 'Poland',
    'PS': 'Palestine',
    'PT': 'Portugal',
    'PY': 'Paraguay',
    'QA': 'Qatar',
    'RO': 'Romania',
    'RS': 'Serbia',
    'RU': 'Russia',
    'SA': 'Saudi Arabia',
    'SC': 'Seychelles',
    'SE': 'Sweden',
    'SG': 'Singapore',
    'SI': 'Slovenia',
    'SK': 'Slovakia',
    'SM': 'San Marino',
    'SN': 'Senegal',
    'SV': 'El Salvador',
    'TC': 'Turks and Caicos Islands',
    'TH': 'Thailand',
    'TN': 'Tunisia',
    'TR': 'Turkey',
    'TT': 'Trinidad and Tobago',
    'TW': 'Taiwan',
    'TZ': 'Tanzania',
    'UA': 'Ukraine',
    'UG': 'Uganda',
    'US': 'United States',
    'UY': 'Uruguay',
    'VA': 'Vatican City',
    'VE': 'Venezuela',
    'VN': 'Vietnam',
    'YE': 'Yemen',
    'ZA': 'South Africa',
    'ZM': 'Zambia',
    'ZW': 'Zimbabwe',
  };
}
```

- [ ] **Step 15: Run Countries tests**

```bash
flutter test test/domain/countries_test.dart
```

Expected: all 5 tests PASS.

- [ ] **Step 16: Run all tests**

```bash
flutter test
```

Expected: all tests PASS.

- [ ] **Step 17: Commit**

```bash
git add lib/data/models/ lib/domain/ test/data/models/ test/domain/
git commit -m "feat: add data models (freezed) and country code map"
```

---

### Task 3: TMDB API Client & Repository

**Files:**
- Create: `lib/data/api/tmdb_repository.dart`, `lib/data/api/tmdb_image_url.dart`
- Test: `test/data/api/tmdb_repository_test.dart`

**Interfaces:**
- Consumes: `SearchResult.fromTmdb(Map)`, `WatchProvider.fromTmdb(Map, ProviderType)`, `CountryAvailability(...)`, `Countries.nameFor(String)`, `Countries.flagFor(String)`, `MediaType`, `ProviderType`
- Produces:
  - `TmdbRepository(Dio dio)`
  - `TmdbRepository.searchMulti(String query) → Future<List<SearchResult>>`
  - `TmdbRepository.getWatchProviders(int id, MediaType mediaType) → Future<List<CountryAvailability>>`
  - `TmdbImageUrl.poster(String path, {String size}) → String`
  - `TmdbImageUrl.logo(String path, {String size}) → String`

- [ ] **Step 1: Write failing tests for TmdbRepository**

Create `test/data/api/tmdb_repository_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchfrom/data/api/tmdb_repository.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TmdbRepository repo;

  setUp(() {
    mockDio = MockDio();
    repo = TmdbRepository(mockDio);
  });

  group('searchMulti', () {
    test('returns filtered results excluding people', () async {
      when(() => mockDio.get(
            '/search/multi',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {
              'results': [
                {
                  'id': 27205,
                  'media_type': 'movie',
                  'title': 'Inception',
                  'release_date': '2010-07-16',
                  'poster_path': '/poster.jpg',
                  'overview': 'A thief...',
                  'vote_average': 8.4,
                },
                {
                  'id': 999,
                  'media_type': 'person',
                  'name': 'Some Actor',
                },
                {
                  'id': 1396,
                  'media_type': 'tv',
                  'name': 'Breaking Bad',
                  'first_air_date': '2008-01-20',
                  'poster_path': '/bb.jpg',
                  'overview': 'A teacher...',
                  'vote_average': 8.9,
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final results = await repo.searchMulti('inception');

      expect(results.length, 2);
      expect(results[0].title, 'Inception');
      expect(results[0].mediaType, MediaType.movie);
      expect(results[1].title, 'Breaking Bad');
      expect(results[1].mediaType, MediaType.tv);
    });

    test('returns empty list when no results', () async {
      when(() => mockDio.get(
            '/search/multi',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {'results': []},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final results = await repo.searchMulti('xyznonexistent');

      expect(results, isEmpty);
    });
  });

  group('getWatchProviders', () {
    test('parses movie watch providers with SG and US', () async {
      when(() => mockDio.get('/movie/27205/watch/providers'))
          .thenAnswer((_) async => Response(
                data: {
                  'id': 27205,
                  'results': {
                    'SG': {
                      'flatrate': [
                        {
                          'provider_id': 8,
                          'provider_name': 'Netflix',
                          'logo_path': '/netflix.jpg',
                        },
                      ],
                      'rent': [
                        {
                          'provider_id': 2,
                          'provider_name': 'Apple TV',
                          'logo_path': '/apple.jpg',
                        },
                      ],
                    },
                    'US': {
                      'flatrate': [
                        {
                          'provider_id': 337,
                          'provider_name': 'Disney Plus',
                          'logo_path': '/disney.jpg',
                        },
                      ],
                    },
                  },
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final availability =
          await repo.getWatchProviders(27205, MediaType.movie);

      expect(availability.length, 2);

      final sg = availability.firstWhere((a) => a.countryCode == 'SG');
      expect(sg.countryName, 'Singapore');
      expect(sg.providers.length, 2);
      expect(
        sg.providers
            .where((p) => p.providerType == ProviderType.flatrate)
            .first
            .providerName,
        'Netflix',
      );

      final us = availability.firstWhere((a) => a.countryCode == 'US');
      expect(us.countryName, 'United States');
      expect(us.providers.length, 1);
    });

    test('uses TV endpoint for TV shows', () async {
      when(() => mockDio.get('/tv/1396/watch/providers'))
          .thenAnswer((_) async => Response(
                data: {'id': 1396, 'results': {}},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final availability =
          await repo.getWatchProviders(1396, MediaType.tv);

      expect(availability, isEmpty);
      verify(() => mockDio.get('/tv/1396/watch/providers')).called(1);
    });

    test('returns empty list when results map is empty', () async {
      when(() => mockDio.get('/movie/1/watch/providers'))
          .thenAnswer((_) async => Response(
                data: {'id': 1, 'results': {}},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final availability =
          await repo.getWatchProviders(1, MediaType.movie);

      expect(availability, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/data/api/tmdb_repository_test.dart
```

Expected: FAIL — `tmdb_repository.dart` doesn't exist.

- [ ] **Step 3: Create `lib/data/api/tmdb_image_url.dart`**

```dart
class TmdbImageUrl {
  TmdbImageUrl._();

  static const _baseUrl = 'https://image.tmdb.org/t/p';

  static String poster(String path, {String size = 'w185'}) =>
      '$_baseUrl/$size$path';

  static String posterLarge(String path, {String size = 'w500'}) =>
      '$_baseUrl/$size$path';

  static String logo(String path, {String size = 'w92'}) =>
      '$_baseUrl/$size$path';
}
```

- [ ] **Step 4: Create `lib/data/api/tmdb_repository.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/domain/countries.dart';

class TmdbRepository {
  TmdbRepository(this._dio);

  final Dio _dio;

  Future<List<SearchResult>> searchMulti(String query) async {
    final response = await _dio.get(
      '/search/multi',
      queryParameters: {
        'query': query,
        'include_adult': false,
      },
    );
    final results = response.data['results'] as List;
    return results
        .where((r) =>
            r['media_type'] == 'movie' || r['media_type'] == 'tv')
        .map((r) => SearchResult.fromTmdb(r as Map<String, dynamic>))
        .toList();
  }

  Future<List<CountryAvailability>> getWatchProviders(
    int id,
    MediaType mediaType,
  ) async {
    final path = mediaType == MediaType.movie
        ? '/movie/$id/watch/providers'
        : '/tv/$id/watch/providers';
    final response = await _dio.get(path);
    final results = response.data['results'] as Map<String, dynamic>;

    return results.entries.map((entry) {
      final code = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final providers = <WatchProvider>[];

      for (final type in ProviderType.values) {
        final list = data[type.name] as List?;
        if (list != null) {
          providers.addAll(
            list.map((p) =>
                WatchProvider.fromTmdb(p as Map<String, dynamic>, type)),
          );
        }
      }

      return CountryAvailability(
        countryCode: code,
        countryName: Countries.nameFor(code) ?? code,
        flagEmoji: Countries.flagFor(code),
        providers: providers,
      );
    }).toList();
  }
}
```

- [ ] **Step 5: Run tests to verify they pass**

```bash
flutter test test/data/api/tmdb_repository_test.dart
```

Expected: all 5 tests PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/data/api/ test/data/api/
git commit -m "feat: add TMDB repository with search and watch provider methods"
```

---

### Task 4: Local Persistence (Hive CE)

**Files:**
- Create: `lib/data/repositories/watchlist_repository.dart`, `lib/data/repositories/search_history_repository.dart`, `lib/data/repositories/hive_helpers.dart`
- Test: `test/data/repositories/watchlist_repository_test.dart`, `test/data/repositories/search_history_repository_test.dart`

**Interfaces:**
- Consumes: `WatchlistItem.toJson()`, `WatchlistItem.fromJson(Map)`, `SearchHistoryEntry.toJson()`, `SearchHistoryEntry.fromJson(Map)`
- Produces:
  - `WatchlistRepository()` with `.save(WatchlistItem)`, `.getAll() → Future<List<WatchlistItem>>`, `.delete(int tmdbId)`, `.exists(int tmdbId) → Future<bool>`
  - `SearchHistoryRepository()` with `.save(String query)`, `.getRecent() → Future<List<SearchHistoryEntry>>`, `.deleteEntry(String query)`, `.clearAll()`

- [ ] **Step 1: Write failing tests for WatchlistRepository**

Create `test/data/repositories/watchlist_repository_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/data/repositories/watchlist_repository.dart';

void main() {
  late Directory tempDir;
  late WatchlistRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('watchlist_test_');
    Hive.init(tempDir.path);
    repo = WatchlistRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  WatchlistItem makeItem({int tmdbId = 27205, String title = 'Inception'}) {
    return WatchlistItem(
      tmdbId: tmdbId,
      title: title,
      mediaType: MediaType.movie,
      posterPath: '/poster.jpg',
      releaseYear: '2010',
      savedAt: DateTime.utc(2026, 8, 24),
      availabilitySnapshot: {
        'US': [
          const WatchProvider(
            providerId: 8,
            providerName: 'Netflix',
            logoPath: '/netflix.jpg',
            providerType: ProviderType.flatrate,
          ),
        ],
      },
    );
  }

  group('WatchlistRepository', () {
    test('save and getAll returns saved item', () async {
      final item = makeItem();
      await repo.save(item);

      final items = await repo.getAll();

      expect(items.length, 1);
      expect(items.first.tmdbId, 27205);
      expect(items.first.title, 'Inception');
      expect(items.first.availabilitySnapshot['US']!.first.providerName,
          'Netflix');
    });

    test('exists returns true for saved item', () async {
      await repo.save(makeItem());

      expect(await repo.exists(27205), isTrue);
      expect(await repo.exists(99999), isFalse);
    });

    test('delete removes item', () async {
      await repo.save(makeItem());
      await repo.delete(27205);

      final items = await repo.getAll();
      expect(items, isEmpty);
    });

    test('save overwrites item with same tmdbId', () async {
      await repo.save(makeItem(title: 'Old Title'));
      await repo.save(makeItem(title: 'New Title'));

      final items = await repo.getAll();
      expect(items.length, 1);
      expect(items.first.title, 'New Title');
    });

    test('getAll returns items sorted by savedAt descending', () async {
      await repo.save(WatchlistItem(
        tmdbId: 1,
        title: 'Older',
        mediaType: MediaType.movie,
        savedAt: DateTime.utc(2026, 1, 1),
        availabilitySnapshot: {},
      ));
      await repo.save(WatchlistItem(
        tmdbId: 2,
        title: 'Newer',
        mediaType: MediaType.tv,
        savedAt: DateTime.utc(2026, 8, 24),
        availabilitySnapshot: {},
      ));

      final items = await repo.getAll();
      expect(items.first.title, 'Newer');
      expect(items.last.title, 'Older');
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/data/repositories/watchlist_repository_test.dart
```

Expected: FAIL — `watchlist_repository.dart` doesn't exist.

- [ ] **Step 3: Create `lib/data/repositories/hive_helpers.dart`**

Hive stores maps as `Map<dynamic, dynamic>`. Freezed's `fromJson` expects `Map<String, dynamic>`. This helper deep-casts nested structures:

```dart
Map<String, dynamic> deepCastMap(Map<dynamic, dynamic> map) {
  return map.map((key, value) => MapEntry(
        key.toString(),
        _deepCastValue(value),
      ));
}

dynamic _deepCastValue(dynamic value) {
  if (value is Map) return deepCastMap(value);
  if (value is List) return value.map(_deepCastValue).toList();
  return value;
}
```

- [ ] **Step 4: Create `lib/data/repositories/watchlist_repository.dart`**

```dart
import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/data/repositories/hive_helpers.dart';

class WatchlistRepository {
  static const _boxName = 'watchlist';

  Future<Box<dynamic>> _openBox() => Hive.openBox(_boxName);

  Future<void> save(WatchlistItem item) async {
    final box = await _openBox();
    await box.put(item.tmdbId.toString(), item.toJson());
  }

  Future<List<WatchlistItem>> getAll() async {
    final box = await _openBox();
    final items = box.values
        .map((value) => WatchlistItem.fromJson(deepCastMap(value as Map)))
        .toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  Future<void> delete(int tmdbId) async {
    final box = await _openBox();
    await box.delete(tmdbId.toString());
  }

  Future<bool> exists(int tmdbId) async {
    final box = await _openBox();
    return box.containsKey(tmdbId.toString());
  }
}
```

- [ ] **Step 5: Run WatchlistRepository tests**

```bash
flutter test test/data/repositories/watchlist_repository_test.dart
```

Expected: all 5 tests PASS.

- [ ] **Step 6: Write failing tests for SearchHistoryRepository**

Create `test/data/repositories/search_history_repository_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/repositories/search_history_repository.dart';

void main() {
  late Directory tempDir;
  late SearchHistoryRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('history_test_');
    Hive.init(tempDir.path);
    repo = SearchHistoryRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('SearchHistoryRepository', () {
    test('save and getRecent returns entry', () async {
      await repo.save('inception');

      final entries = await repo.getRecent();

      expect(entries.length, 1);
      expect(entries.first.query, 'inception');
    });

    test('saving same query updates timestamp', () async {
      await repo.save('inception');
      await Future.delayed(const Duration(milliseconds: 10));
      await repo.save('inception');

      final entries = await repo.getRecent();
      expect(entries.length, 1);
    });

    test('getRecent returns entries sorted newest first', () async {
      await repo.save('first');
      await Future.delayed(const Duration(milliseconds: 10));
      await repo.save('second');

      final entries = await repo.getRecent();
      expect(entries.first.query, 'second');
      expect(entries.last.query, 'first');
    });

    test('deleteEntry removes specific entry', () async {
      await repo.save('keep');
      await repo.save('remove');
      await repo.deleteEntry('remove');

      final entries = await repo.getRecent();
      expect(entries.length, 1);
      expect(entries.first.query, 'keep');
    });

    test('clearAll removes all entries', () async {
      await repo.save('one');
      await repo.save('two');
      await repo.clearAll();

      final entries = await repo.getRecent();
      expect(entries, isEmpty);
    });

    test('prunes to 50 entries', () async {
      for (int i = 0; i < 55; i++) {
        await repo.save('query_$i');
      }

      final entries = await repo.getRecent();
      expect(entries.length, 50);
    });
  });
}
```

- [ ] **Step 7: Run test to verify it fails**

```bash
flutter test test/data/repositories/search_history_repository_test.dart
```

Expected: FAIL — `search_history_repository.dart` doesn't exist.

- [ ] **Step 8: Create `lib/data/repositories/search_history_repository.dart`**

```dart
import 'package:hive_ce/hive_ce.dart';
import 'package:watchfrom/data/models/search_history_entry.dart';
import 'package:watchfrom/data/repositories/hive_helpers.dart';

class SearchHistoryRepository {
  static const _boxName = 'search_history';
  static const _maxEntries = 50;

  Future<Box<dynamic>> _openBox() => Hive.openBox(_boxName);

  Future<void> save(String query) async {
    final box = await _openBox();
    final entry = SearchHistoryEntry(
      query: query,
      searchedAt: DateTime.now(),
    );
    await box.put(query, entry.toJson());
    await _prune(box);
  }

  Future<void> _prune(Box<dynamic> box) async {
    if (box.length <= _maxEntries) return;
    final entries = box.keys.map((key) {
      final value = deepCastMap(box.get(key) as Map);
      return MapEntry(
        key,
        DateTime.parse(value['searchedAt'] as String),
      );
    }).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final toRemove = entries.take(box.length - _maxEntries);
    for (final entry in toRemove) {
      await box.delete(entry.key);
    }
  }

  Future<List<SearchHistoryEntry>> getRecent() async {
    final box = await _openBox();
    final entries = box.values
        .map((value) =>
            SearchHistoryEntry.fromJson(deepCastMap(value as Map)))
        .toList();
    entries.sort((a, b) => b.searchedAt.compareTo(a.searchedAt));
    return entries;
  }

  Future<void> deleteEntry(String query) async {
    final box = await _openBox();
    await box.delete(query);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
```

- [ ] **Step 9: Run SearchHistoryRepository tests**

```bash
flutter test test/data/repositories/search_history_repository_test.dart
```

Expected: all 6 tests PASS.

- [ ] **Step 10: Run all tests**

```bash
flutter test
```

Expected: all tests PASS.

- [ ] **Step 11: Commit**

```bash
git add lib/data/repositories/ test/data/repositories/
git commit -m "feat: add Hive-backed watchlist and search history repositories"
```

---

### Task 5: State Management (Riverpod Providers)

**Files:**
- Create: `lib/presentation/providers/repository_providers.dart`, `lib/presentation/providers/search_providers.dart`, `lib/presentation/providers/watchlist_providers.dart`, `lib/presentation/providers/search_history_providers.dart`

**Interfaces:**
- Consumes: `TmdbRepository(Dio)`, `WatchlistRepository()`, `SearchHistoryRepository()`, `dotenv.env['TMDB_API_READ_ACCESS_TOKEN']`
- Produces:
  - `dioProvider → Provider<Dio>`
  - `tmdbRepositoryProvider → Provider<TmdbRepository>`
  - `watchlistRepositoryProvider → Provider<WatchlistRepository>`
  - `searchHistoryRepositoryProvider → Provider<SearchHistoryRepository>`
  - `searchQueryProvider → StateProvider<String>`
  - `searchResultsProvider → FutureProvider.autoDispose<List<SearchResult>>`
  - `watchProvidersProvider → FutureProvider.autoDispose.family<List<CountryAvailability>, ({int id, MediaType mediaType})>`
  - `watchlistProvider → AsyncNotifierProvider<WatchlistNotifier, List<WatchlistItem>>`
  - `searchHistoryProvider → AsyncNotifierProvider<SearchHistoryNotifier, List<SearchHistoryEntry>>`

- [ ] **Step 1: Create `lib/presentation/providers/repository_providers.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/api/tmdb_repository.dart';
import 'package:watchfrom/data/repositories/search_history_repository.dart';
import 'package:watchfrom/data/repositories/watchlist_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final token = dotenv.env['TMDB_API_READ_ACCESS_TOKEN']!;
  return Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  ));
});

final tmdbRepositoryProvider = Provider<TmdbRepository>((ref) {
  return TmdbRepository(ref.watch(dioProvider));
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

final searchHistoryRepositoryProvider =
    Provider<SearchHistoryRepository>((ref) {
  return SearchHistoryRepository();
});
```

- [ ] **Step 2: Create `lib/presentation/providers/search_providers.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/presentation/providers/repository_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<List<SearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return ref.read(tmdbRepositoryProvider).searchMulti(query);
});

typedef WatchProviderParams = ({int id, MediaType mediaType});

final watchProvidersProvider = FutureProvider.autoDispose
    .family<List<CountryAvailability>, WatchProviderParams>(
  (ref, params) async {
    return ref
        .read(tmdbRepositoryProvider)
        .getWatchProviders(params.id, params.mediaType);
  },
);
```

- [ ] **Step 3: Create `lib/presentation/providers/watchlist_providers.dart`**

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/repository_providers.dart';

final watchlistProvider =
    AsyncNotifierProvider<WatchlistNotifier, List<WatchlistItem>>(
  WatchlistNotifier.new,
);

class WatchlistNotifier extends AsyncNotifier<List<WatchlistItem>> {
  @override
  FutureOr<List<WatchlistItem>> build() {
    return ref.read(watchlistRepositoryProvider).getAll();
  }

  Future<void> add(WatchlistItem item) async {
    await ref.read(watchlistRepositoryProvider).save(item);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(int tmdbId) async {
    await ref.read(watchlistRepositoryProvider).delete(tmdbId);
    ref.invalidateSelf();
    await future;
  }

  Future<bool> exists(int tmdbId) {
    return ref.read(watchlistRepositoryProvider).exists(tmdbId);
  }
}
```

- [ ] **Step 4: Create `lib/presentation/providers/search_history_providers.dart`**

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/models/search_history_entry.dart';
import 'package:watchfrom/presentation/providers/repository_providers.dart';

final searchHistoryProvider =
    AsyncNotifierProvider<SearchHistoryNotifier, List<SearchHistoryEntry>>(
  SearchHistoryNotifier.new,
);

class SearchHistoryNotifier
    extends AsyncNotifier<List<SearchHistoryEntry>> {
  @override
  FutureOr<List<SearchHistoryEntry>> build() {
    return ref.read(searchHistoryRepositoryProvider).getRecent();
  }

  Future<void> add(String query) async {
    await ref.read(searchHistoryRepositoryProvider).save(query);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(String query) async {
    await ref.read(searchHistoryRepositoryProvider).deleteEntry(query);
    ref.invalidateSelf();
    await future;
  }

  Future<void> clearAll() async {
    await ref.read(searchHistoryRepositoryProvider).clearAll();
    ref.invalidateSelf();
    await future;
  }
}
```

- [ ] **Step 5: Verify the app still builds**

```bash
flutter build apk --debug
```

Expected: BUILD SUCCESSFUL (providers are defined but not yet used in UI).

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/providers/
git commit -m "feat: add Riverpod providers for search, watchlist, and history"
```

---

### Task 6: Search Screen

**Files:**
- Modify: `lib/presentation/screens/search_screen.dart`
- Create: `lib/presentation/widgets/search_result_card.dart`, `lib/presentation/widgets/search_history_list.dart`
- Test: `test/presentation/screens/search_screen_test.dart`

**Interfaces:**
- Consumes: `searchQueryProvider`, `searchResultsProvider`, `searchHistoryProvider` (from Task 5), `SearchResult`, `SearchHistoryEntry` (from Task 2), `TmdbImageUrl.poster()` (from Task 3)
- Produces: Working search screen with debounced input, results list, and inline search history

- [ ] **Step 1: Write widget test for search screen**

Create `test/presentation/screens/search_screen_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/presentation/screens/search_screen_test.dart
```

Expected: FAIL — SearchScreen is still a placeholder.

- [ ] **Step 3: Create `lib/presentation/widgets/search_result_card.dart`**

```dart
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
```

- [ ] **Step 4: Create `lib/presentation/widgets/search_history_list.dart`**

```dart
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
```

- [ ] **Step 5: Rewrite `lib/presentation/screens/search_screen.dart`**

```dart
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
```

- [ ] **Step 6: Update `lib/config/router.dart` to add detail route**

```dart
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
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        final result = extra['searchResult'] as SearchResult;
        final snapshot = extra['snapshot'] as Map<String, List<WatchProvider>>?;
        return DetailScreen(searchResult: result, savedSnapshot: snapshot);
      },
    ),
  ],
);
```

Create a stub `lib/presentation/screens/detail_screen.dart` (full implementation in Task 7):

```dart
import 'package:flutter/material.dart';
import 'package:watchfrom/data/models/search_result.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.searchResult});

  final SearchResult searchResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(searchResult.title)),
      body: const Center(child: Text('Detail coming soon')),
    );
  }
}
```

- [ ] **Step 7: Run search screen widget tests**

```bash
flutter test test/presentation/screens/search_screen_test.dart
```

Expected: tests PASS. If `overrideWith` syntax needs adjustment for the Riverpod version, adjust the test overrides accordingly.

- [ ] **Step 8: Run the app and test search manually**

```bash
flutter run
```

Verify: type a movie name, see results after 500ms debounce, tap a result to see stub detail screen, see search history on return.

- [ ] **Step 9: Commit**

```bash
git add lib/presentation/screens/ lib/presentation/widgets/ lib/config/router.dart test/presentation/
git commit -m "feat: implement search screen with debounce, results, and history"
```

---

### Task 7: Detail Screen

**Files:**
- Modify: `lib/presentation/screens/detail_screen.dart`
- Create: `lib/presentation/widgets/sg_availability_section.dart`, `lib/presentation/widgets/worldwide_availability_section.dart`, `lib/presentation/widgets/provider_logo.dart`
- Test: `test/presentation/screens/detail_screen_test.dart`

**Interfaces:**
- Consumes: `watchProvidersProvider` (from Task 5), `watchlistProvider` (from Task 5), `SearchResult`, `CountryAvailability`, `WatchProvider`, `WatchlistItem`, `ProviderType`, `MediaType`, `Countries`, `TmdbImageUrl`
- Produces: Detail screen showing title info, SG availability section, worldwide availability section, and save-to-watchlist button

- [ ] **Step 1: Write widget test for detail screen**

Create `test/presentation/screens/detail_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/screens/detail_screen.dart';

const _testResult = SearchResult(
  id: 27205,
  title: 'Inception',
  mediaType: MediaType.movie,
  posterPath: '/poster.jpg',
  releaseYear: '2010',
  overview: 'A thief who steals secrets through dreams.',
  voteAverage: 8.4,
);

final _sgAvailable = [
  const CountryAvailability(
    countryCode: 'SG',
    countryName: 'Singapore',
    flagEmoji: '🇸🇬',
    providers: [
      WatchProvider(
        providerId: 8,
        providerName: 'Netflix',
        logoPath: '/netflix.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
  const CountryAvailability(
    countryCode: 'US',
    countryName: 'United States',
    flagEmoji: '🇺🇸',
    providers: [
      WatchProvider(
        providerId: 337,
        providerName: 'Disney Plus',
        logoPath: '/disney.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
];

final _sgNotAvailable = [
  const CountryAvailability(
    countryCode: 'US',
    countryName: 'United States',
    flagEmoji: '🇺🇸',
    providers: [
      WatchProvider(
        providerId: 8,
        providerName: 'Netflix',
        logoPath: '/netflix.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
  const CountryAvailability(
    countryCode: 'GB',
    countryName: 'United Kingdom',
    flagEmoji: '🇬🇧',
    providers: [
      WatchProvider(
        providerId: 8,
        providerName: 'Netflix',
        logoPath: '/netflix.jpg',
        providerType: ProviderType.flatrate,
      ),
    ],
  ),
];

void main() {
  group('DetailScreen', () {
    testWidgets('shows SG available section when SG has flatrate',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchProvidersProvider((id: 27205, mediaType: MediaType.movie))
                .overrideWith((ref) => Future.value(_sgAvailable)),
            watchlistProvider.overrideWith(
              () => _FakeWatchlistNotifier(),
            ),
          ],
          child: const MaterialApp(
            home: DetailScreen(searchResult: _testResult),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Available in Singapore'), findsOneWidget);
      expect(find.text('Netflix'), findsWidgets);
    });

    testWidgets('shows not available banner when SG has no flatrate',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchProvidersProvider((id: 27205, mediaType: MediaType.movie))
                .overrideWith((ref) => Future.value(_sgNotAvailable)),
            watchlistProvider.overrideWith(
              () => _FakeWatchlistNotifier(),
            ),
          ],
          child: const MaterialApp(
            home: DetailScreen(searchResult: _testResult),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Not available for streaming in Singapore'),
          findsOneWidget);
    });

    testWidgets('shows availability changed banner when snapshot differs',
        (tester) async {
      final oldSnapshot = {
        'US': [
          const WatchProvider(
            providerId: 337,
            providerName: 'Disney Plus',
            logoPath: '/disney.jpg',
            providerType: ProviderType.flatrate,
          ),
        ],
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchProvidersProvider((id: 27205, mediaType: MediaType.movie))
                .overrideWith((ref) => Future.value(_sgNotAvailable)),
            watchlistProvider.overrideWith(
              () => _FakeWatchlistNotifier(),
            ),
          ],
          child: MaterialApp(
            home: DetailScreen(
              searchResult: _testResult,
              savedSnapshot: oldSnapshot,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Availability has changed since you saved this'),
        findsOneWidget,
      );
    });
  });
}

class _FakeWatchlistNotifier extends WatchlistNotifier {
  @override
  FutureOr<List<WatchlistItem>> build() => [];
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/presentation/screens/detail_screen_test.dart
```

Expected: FAIL — DetailScreen is still a stub.

- [ ] **Step 3: Create `lib/presentation/widgets/provider_logo.dart`**

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';

class ProviderLogo extends StatelessWidget {
  const ProviderLogo({
    super.key,
    required this.logoPath,
    this.size = 40,
  });

  final String logoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: TmdbImageUrl.logo(logoPath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => SizedBox(
          width: size,
          height: size,
          child: const ColoredBox(
            color: Colors.grey,
            child: Icon(Icons.tv, size: 20),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create `lib/presentation/widgets/sg_availability_section.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/presentation/widgets/provider_logo.dart';

class SgAvailabilitySection extends StatelessWidget {
  const SgAvailabilitySection({super.key, this.sgAvailability});

  final CountryAvailability? sgAvailability;

  @override
  Widget build(BuildContext context) {
    final hasFlatrate = sgAvailability != null &&
        sgAvailability!.providers
            .any((p) => p.providerType == ProviderType.flatrate);

    if (!hasFlatrate) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.vpn_lock, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Not available for streaming in Singapore',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    final grouped = <ProviderType, List<WatchProvider>>{};
    for (final p in sgAvailability!.providers) {
      grouped.putIfAbsent(p.providerType, () => []).add(p);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🇸🇬',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 8),
              Text(
                'Available in Singapore',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final type in [
            ProviderType.flatrate,
            ProviderType.rent,
            ProviderType.buy,
          ])
            if (grouped.containsKey(type)) ...[
              Text(
                _typeLabel(type),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: grouped[type]!
                    .map((p) => Chip(
                          avatar: ProviderLogo(
                              logoPath: p.logoPath, size: 24),
                          label: Text(p.providerName),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  String _typeLabel(ProviderType type) {
    switch (type) {
      case ProviderType.flatrate:
        return 'Stream';
      case ProviderType.rent:
        return 'Rent';
      case ProviderType.buy:
        return 'Buy';
    }
  }
}
```

- [ ] **Step 5: Create `lib/presentation/widgets/worldwide_availability_section.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/presentation/widgets/provider_logo.dart';

class WorldwideAvailabilitySection extends StatelessWidget {
  const WorldwideAvailabilitySection({
    super.key,
    required this.availability,
  });

  final List<CountryAvailability> availability;

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByProvider(availability);

    if (grouped.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No streaming availability data found'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available worldwide via VPN',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...grouped.map((entry) => _ProviderRow(entry: entry)),
        ],
      ),
    );
  }

  List<_ProviderCountries> _groupByProvider(
    List<CountryAvailability> availability,
  ) {
    final map = <int, _ProviderCountries>{};
    for (final country in availability) {
      for (final provider in country.providers
          .where((p) => p.providerType == ProviderType.flatrate)) {
        map
            .putIfAbsent(
              provider.providerId,
              () => _ProviderCountries(provider: provider, countries: []),
            )
            .countries
            .add(_CountryInfo(
              code: country.countryCode,
              name: country.countryName,
              flag: country.flagEmoji,
            ));
      }
    }
    final result = map.values.toList()
      ..sort((a, b) => b.countries.length.compareTo(a.countries.length));
    return result;
  }
}

class _ProviderCountries {
  _ProviderCountries({required this.provider, required this.countries});
  final WatchProvider provider;
  final List<_CountryInfo> countries;
}

class _CountryInfo {
  _CountryInfo({
    required this.code,
    required this.name,
    required this.flag,
  });
  final String code;
  final String name;
  final String flag;
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({required this.entry});

  final _ProviderCountries entry;

  @override
  Widget build(BuildContext context) {
    final displayCountries = entry.countries.take(5).toList();
    final remaining = entry.countries.length - displayCountries.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProviderLogo(logoPath: entry.provider.logoPath),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.provider.providerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    ...displayCountries.map((c) => Text(
                          '${c.flag} ${c.name}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                    if (remaining > 0)
                      Text(
                        '+$remaining more',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Rewrite `lib/presentation/screens/detail_screen.dart`**

The detail screen accepts an optional `availabilitySnapshot` (from the watchlist). When live data loads, it compares against the snapshot and shows an "availability changed" banner if they differ.

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';
import 'package:watchfrom/data/models/country_availability.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/search_providers.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/widgets/sg_availability_section.dart';
import 'package:watchfrom/presentation/widgets/worldwide_availability_section.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({
    super.key,
    required this.searchResult,
    this.savedSnapshot,
  });

  final SearchResult searchResult;
  final Map<String, List<WatchProvider>>? savedSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (id: searchResult.id, mediaType: searchResult.mediaType);
    final availabilityAsync = ref.watch(watchProvidersProvider(params));

    return Scaffold(
      appBar: AppBar(title: Text(searchResult.title)),
      body: availabilityAsync.when(
        data: (availability) => _buildContent(context, ref, availability),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(watchProvidersProvider(params)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<CountryAvailability> availability,
  ) {
    final sg = availability
        .where((a) => a.countryCode == 'SG')
        .firstOrNull;
    final worldwide = availability
        .where((a) => a.countryCode != 'SG')
        .toList();
    final hasChanged = savedSnapshot != null &&
        _availabilityChanged(availability, savedSnapshot!);

    return ListView(
      children: [
        _buildHeader(context),
        if (hasChanged)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Text('Availability has changed since you saved this'),
              ],
            ),
          ),
        const Divider(),
        SgAvailabilitySection(sgAvailability: sg),
        if (worldwide.isNotEmpty) ...[
          const Divider(),
          WorldwideAvailabilitySection(availability: worldwide),
        ],
        const SizedBox(height: 24),
        _buildWatchlistButton(context, ref, availability),
        const SizedBox(height: 32),
      ],
    );
  }

  bool _availabilityChanged(
    List<CountryAvailability> live,
    Map<String, List<WatchProvider>> snapshot,
  ) {
    final liveMap = <String, Set<int>>{};
    for (final country in live) {
      liveMap[country.countryCode] = country.providers
          .where((p) => p.providerType == ProviderType.flatrate)
          .map((p) => p.providerId)
          .toSet();
    }
    final snapshotMap = <String, Set<int>>{};
    for (final entry in snapshot.entries) {
      snapshotMap[entry.key] = entry.value
          .where((p) => p.providerType == ProviderType.flatrate)
          .map((p) => p.providerId)
          .toSet();
    }
    if (liveMap.keys.length != snapshotMap.keys.length) return true;
    for (final code in liveMap.keys) {
      if (!snapshotMap.containsKey(code)) return true;
      if (!liveMap[code]!.containsAll(snapshotMap[code]!) ||
          !snapshotMap[code]!.containsAll(liveMap[code]!)) {
        return true;
      }
    }
    return false;
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchResult.posterPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    TmdbImageUrl.posterLarge(searchResult.posterPath!),
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  searchResult.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (searchResult.releaseYear != null)
                      Text(searchResult.releaseYear!),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        searchResult.mediaType == MediaType.movie
                            ? 'Movie'
                            : 'TV',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    if (searchResult.voteAverage != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.star,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(searchResult.voteAverage!
                          .toStringAsFixed(1)),
                    ],
                  ],
                ),
                if (searchResult.overview != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    searchResult.overview!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistButton(
    BuildContext context,
    WidgetRef ref,
    List<CountryAvailability> availability,
  ) {
    final watchlistAsync = ref.watch(watchlistProvider);

    return watchlistAsync.when(
      data: (items) {
        final isInWatchlist =
            items.any((item) => item.tmdbId == searchResult.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.icon(
            onPressed: () {
              if (isInWatchlist) {
                ref
                    .read(watchlistProvider.notifier)
                    .remove(searchResult.id);
              } else {
                final snapshot = <String, List<WatchProvider>>{};
                for (final country in availability) {
                  snapshot[country.countryCode] = country.providers;
                }
                ref.read(watchlistProvider.notifier).add(WatchlistItem(
                      tmdbId: searchResult.id,
                      title: searchResult.title,
                      mediaType: searchResult.mediaType,
                      posterPath: searchResult.posterPath,
                      releaseYear: searchResult.releaseYear,
                      savedAt: DateTime.now(),
                      availabilitySnapshot: snapshot,
                    ));
              }
            },
            icon: Icon(
                isInWatchlist ? Icons.bookmark : Icons.bookmark_outline),
            label: Text(
              isInWatchlist ? 'Remove from Watchlist' : 'Save to Watchlist',
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 7: Run detail screen widget tests**

```bash
flutter test test/presentation/screens/detail_screen_test.dart
```

Expected: tests PASS. Adjust provider override syntax if needed for your Riverpod version.

- [ ] **Step 8: Run the app and test the detail flow manually**

```bash
flutter run
```

Verify: search a movie → tap result → see poster/title/year/rating → see SG availability (or "not available" banner) → see worldwide providers → tap "Save to Watchlist" → button changes to "Remove from Watchlist".

- [ ] **Step 9: Commit**

```bash
git add lib/presentation/screens/detail_screen.dart lib/presentation/widgets/ test/presentation/screens/detail_screen_test.dart
git commit -m "feat: implement detail screen with SG-first availability and watchlist save"
```

---

### Task 8: Watchlist Screen

**Files:**
- Modify: `lib/presentation/screens/watchlist_screen.dart`
- Create: `lib/presentation/widgets/watchlist_card.dart`
- Test: `test/presentation/screens/watchlist_screen_test.dart`

**Interfaces:**
- Consumes: `watchlistProvider` (from Task 5), `watchProvidersProvider` (from Task 5), `WatchlistItem`, `WatchProvider`, `ProviderType`, `TmdbImageUrl`, `SearchResult`, `MediaType`
- Produces: Watchlist tab showing saved titles with at-a-glance provider/country summaries, swipe-to-delete, tap to navigate to detail screen

- [ ] **Step 1: Write widget test for watchlist screen**

Create `test/presentation/screens/watchlist_screen_test.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';
import 'package:watchfrom/presentation/providers/watchlist_providers.dart';
import 'package:watchfrom/presentation/screens/watchlist_screen.dart';

void main() {
  group('WatchlistScreen', () {
    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchlistProvider
                .overrideWith(() => _FakeWatchlistNotifier([])),
          ],
          child: const MaterialApp(home: WatchlistScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your watchlist is empty'), findsOneWidget);
    });

    testWidgets('shows watchlist items with provider summary',
        (tester) async {
      final items = [
        WatchlistItem(
          tmdbId: 27205,
          title: 'Inception',
          mediaType: MediaType.movie,
          releaseYear: '2010',
          savedAt: DateTime.utc(2026, 8, 24),
          availabilitySnapshot: {
            'US': [
              const WatchProvider(
                providerId: 8,
                providerName: 'Netflix',
                logoPath: '/netflix.jpg',
                providerType: ProviderType.flatrate,
              ),
            ],
            'GB': [
              const WatchProvider(
                providerId: 8,
                providerName: 'Netflix',
                logoPath: '/netflix.jpg',
                providerType: ProviderType.flatrate,
              ),
            ],
          },
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            watchlistProvider
                .overrideWith(() => _FakeWatchlistNotifier(items)),
          ],
          child: const MaterialApp(home: WatchlistScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inception'), findsOneWidget);
      expect(find.textContaining('Netflix'), findsOneWidget);
    });
  });
}

class _FakeWatchlistNotifier extends WatchlistNotifier {
  _FakeWatchlistNotifier(this._items);
  final List<WatchlistItem> _items;

  @override
  FutureOr<List<WatchlistItem>> build() => _items;
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/presentation/screens/watchlist_screen_test.dart
```

Expected: FAIL — WatchlistScreen is still a placeholder.

- [ ] **Step 3: Create `lib/presentation/widgets/watchlist_card.dart`**

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';
import 'package:watchfrom/data/models/search_result.dart';
import 'package:watchfrom/data/models/watch_provider.dart';
import 'package:watchfrom/data/models/watchlist_item.dart';

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final WatchlistItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final summary = _buildSummary();

    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 48,
          height: 72,
          child: item.posterPath != null
              ? CachedNetworkImage(
                  imageUrl: TmdbImageUrl.poster(item.posterPath!),
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
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.releaseYear != null) ...[
                Text(item.releaseYear!),
                const SizedBox(width: 8),
              ],
              Text(
                item.mediaType == MediaType.movie ? 'Movie' : 'TV',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          if (summary.isNotEmpty)
            Text(
              summary,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      isThreeLine: summary.isNotEmpty,
    );
  }

  String _buildSummary() {
    final providerCountries = <String, List<String>>{};
    for (final entry in item.availabilitySnapshot.entries) {
      for (final p in entry.value) {
        if (p.providerType == ProviderType.flatrate) {
          providerCountries
              .putIfAbsent(p.providerName, () => [])
              .add(entry.key);
        }
      }
    }
    if (providerCountries.isEmpty) return '';

    final sorted = providerCountries.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    final top = sorted.first;
    final countryCodes = top.value.take(3).join(', ');
    final remaining = top.value.length - 3;

    if (remaining > 0) {
      return '${top.key}: $countryCodes +$remaining more';
    }
    return '${top.key}: $countryCodes';
  }
}
```

- [ ] **Step 4: Rewrite `lib/presentation/screens/watchlist_screen.dart`**

```dart
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
```

- [ ] **Step 5: Run watchlist screen widget tests**

```bash
flutter test test/presentation/screens/watchlist_screen_test.dart
```

Expected: tests PASS.

- [ ] **Step 6: Run all tests**

```bash
flutter test
```

Expected: all tests PASS.

- [ ] **Step 7: Run the app and test full flow manually**

```bash
flutter run
```

Verify the complete flow:
1. Search for "Inception" → results appear
2. Tap "Inception" → detail screen with SG availability check
3. See worldwide providers with country flags
4. Tap "Save to Watchlist" → button changes to "Remove"
5. Go back → switch to Watchlist tab
6. See "Inception" card with provider summary (e.g., "Netflix: US, GB +5 more")
7. Tap watchlist item → opens detail with live TMDB data refresh
8. Swipe left on watchlist item → removed with undo snackbar

- [ ] **Step 8: Commit**

```bash
git add lib/presentation/screens/watchlist_screen.dart lib/presentation/widgets/watchlist_card.dart test/presentation/screens/watchlist_screen_test.dart
git commit -m "feat: implement watchlist screen with swipe-to-delete and provider summaries"
```
