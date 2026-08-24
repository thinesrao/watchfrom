# WatchFrom — Design Spec

A personal Flutter mobile app that searches for movies and TV shows, checks streaming availability in Singapore first, then shows worldwide availability so you know which VPN server to connect to.

## Architecture

### Three Layers

- **Data layer** — TMDB API client (Dio with auth interceptor), typed response models (freezed + json_serializable), Isar local database for watchlist and search history
- **Domain layer** — Repository interfaces and use cases: `SearchTitles`, `GetWatchProviders`, `ManageWatchlist`, `ManageSearchHistory`
- **Presentation layer** — Flutter widgets with Riverpod providers for state management

### Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `dio` | HTTP client with interceptors |
| `go_router` | Declarative navigation |
| `cached_network_image` | TMDB poster caching |
| `freezed` + `json_serializable` | Immutable data models |
| `isar` + `isar_flutter_libs` | Local NoSQL database |
| `flutter_dotenv` | Load TMDB API key from `.env.local` |

### Navigation

Two bottom tabs:

1. **Search** — search bar + results list + inline search history
2. **Watchlist** — saved titles with at-a-glance VPN info

Tapping a search result or watchlist item pushes a **Detail Screen** on top.

## Data Models

### SearchResult

```
- id: int (TMDB ID)
- title: String (movie title or TV show name)
- mediaType: enum (movie, tv)
- posterPath: String? (TMDB poster URL path)
- releaseYear: String? (extracted from release_date or first_air_date)
- overview: String?
- voteAverage: double?
```

### WatchProvider

```
- providerId: int
- providerName: String
- logoPath: String (TMDB logo URL path)
- providerType: enum (flatrate, rent, buy)
```

### CountryAvailability

```
- countryCode: String (ISO 3166-1, e.g. "SG", "US")
- countryName: String (resolved locally from code)
- flagEmoji: String
- providers: List<WatchProvider>
```

### WatchlistItem

```
- id: int (auto-generated, Isar primary key)
- tmdbId: int
- title: String
- mediaType: enum (movie, tv)
- posterPath: String?
- releaseYear: String?
- savedAt: DateTime
- availabilitySnapshot: Map<String, List<WatchProvider>> (country code -> providers at save time)
```

### SearchHistoryEntry

```
- id: int (auto-generated)
- query: String
- searchedAt: DateTime
```

## API Integration

### TMDB Endpoints

**Search:**
- `GET /search/multi?query={text}&include_adult=false&api_key={key}`
- Returns mixed results; filter to `media_type: "movie"` and `media_type: "tv"` only (ignore people)

**Watch Providers:**
- `GET /movie/{movie_id}/watch/providers?api_key={key}`
- `GET /tv/{tv_id}/watch/providers?api_key={key}`
- Returns `results`: map of ISO country codes to `{ flatrate: [], rent: [], buy: [] }`

**Auth:**
- API key passed as query parameter (`api_key`) or Bearer token in Authorization header (read access token)
- Key loaded from `.env.local` via `flutter_dotenv`

### Rate Limiting

TMDB allows 40 requests per 10 seconds. For personal single-user use this is effectively unlimited. Dio interceptor handles 429 responses with exponential backoff as a safety net.

## Core Flow

### Search Flow

1. User types in search bar
2. Input debounced at 500ms
3. Query saved to search history (Isar)
4. Call TMDB `/search/multi`
5. Filter to movies and TV shows
6. Display as scrollable list: poster, title, year, type badge (Movie/TV)

### Search History (Inline)

- When search bar is empty or focused, show recent searches below it
- Tap a recent search to re-run it
- Clear individual entries or clear all
- Capped at 50 entries, oldest auto-pruned on insert

### Detail Screen — Watch Provider Flow

1. Receive search result (TMDB ID + media type)
2. Call appropriate watch provider endpoint
3. Parse response into CountryAvailability list

**Singapore-first logic:**

1. Check if `results["SG"]` exists in the response
2. If SG has `flatrate` providers:
   - Show "Available in Singapore" section with provider logos
   - Also show `rent` and `buy` if present, clearly labeled
3. If SG has no `flatrate` (or SG is absent entirely):
   - Show "Not available for streaming in Singapore" banner
4. Below the SG section, show worldwide availability:
   - Group by provider name across all countries (excluding SG)
   - Display as: provider logo + name, then list of countries (flag + name)
   - Example: "Netflix — US, UK, AU, JP (15 countries)"
   - This directly answers "which VPN server do I connect to?"

### Watchlist Flow

1. On detail screen, "Save to Watchlist" button
2. Saves title info + streaming availability snapshot to Isar
3. Watchlist tab shows saved titles as cards with:
   - Poster, title, year
   - Quick summary: top provider + country count (e.g., "Netflix: US, UK +13")
4. Tap a watchlist item → opens detail screen with **live refresh** from TMDB
5. If refreshed data differs from snapshot → subtle "availability changed" indicator
6. Swipe to remove from watchlist

## Country Code Resolution

Bundle a static map of ISO 3166-1 alpha-2 codes to country names and flag emoji. Approximately 250 entries, embedded in the app — no extra API call needed.

Example: `"SG"` → `("Singapore", "🇸🇬")`

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Network failure | Inline error message with retry button |
| TMDB rate limit (429) | Dio interceptor retries with exponential backoff |
| Invalid/expired API key | Clear error on search screen |
| No search results | "No movies or TV shows found" empty state |
| Title has no watch provider data | "No streaming availability data found" message |
| SG has rent/buy but no flatrate | Show SG section with "Rent" / "Buy" labels, not "Stream" |

## Testing Strategy

### Unit Tests

- TMDB API client: mock Dio responses, verify parsing for search, watch providers, edge cases (empty results, missing fields)
- Singapore-first logic: given a provider map, verify SG extraction and worldwide grouping
- Watchlist repository: save, load, delete, snapshot-vs-refresh diff detection
- Search history repository: save, load, prune at 50 cap

### Widget Tests

- Search screen: debounce behavior, empty state, loading state, results rendering, search history display
- Detail screen: SG-available vs not-available layouts, provider grouping, save-to-watchlist button state
- Watchlist screen: list rendering, swipe-to-delete, "availability changed" badge

### Integration Tests

- Full flow: search → detail → save to watchlist → open watchlist → tap to refresh
- All tests mock the TMDB API boundary — no live API calls in tests

### Coverage Target

80%+ on data and domain layers. Lighter coverage on pure UI widgets.

## File Structure

```
lib/
  main.dart
  app.dart
  config/
    env.dart                    # flutter_dotenv setup
    router.dart                 # go_router configuration
    theme.dart                  # app theme
  data/
    api/
      tmdb_client.dart          # Dio client + auth interceptor
      tmdb_endpoints.dart       # endpoint constants
    models/
      search_result.dart        # freezed model
      watch_provider.dart       # freezed model
      country_availability.dart # freezed model
      watchlist_item.dart       # Isar collection
      search_history_entry.dart # Isar collection
    repositories/
      tmdb_repository.dart      # TMDB API calls
      watchlist_repository.dart  # Isar watchlist CRUD
      search_history_repository.dart # Isar history CRUD
  domain/
    countries.dart              # static country code map
  presentation/
    providers/
      search_provider.dart      # search state + debounce
      watch_providers_provider.dart # streaming availability state
      watchlist_provider.dart    # watchlist state
    screens/
      search_screen.dart        # search tab
      watchlist_screen.dart     # watchlist tab
      detail_screen.dart        # title detail + availability
    widgets/
      search_bar.dart
      search_result_card.dart
      search_history_list.dart
      provider_logo.dart
      sg_availability_section.dart
      worldwide_availability_section.dart
      watchlist_card.dart
      empty_state.dart
      error_state.dart
test/
  data/
    api/
      tmdb_client_test.dart
    repositories/
      tmdb_repository_test.dart
      watchlist_repository_test.dart
      search_history_repository_test.dart
  domain/
    countries_test.dart
  presentation/
    screens/
      search_screen_test.dart
      detail_screen_test.dart
      watchlist_screen_test.dart
```

## Future Enhancements (Not in Scope)

- JustWatch GraphQL API for niche platform coverage
- TV show season-level availability
- Push notifications when availability changes for watchlist items
- Multiple home countries
