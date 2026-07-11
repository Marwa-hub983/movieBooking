# MovieApp

A Netflix-inspired Flutter movie browsing app powered by [The Movie Database (TMDB)](https://www.themoviedb.org/) API. Browse trending, popular, top-rated, and upcoming titles, search the catalog, and navigate with a persistent bottom tab shell — built with Clean Architecture and BLoC.

## Features

- Browse **Trending** movies
- Browse **Popular** movies
- Browse **Top Rated** movies
- Browse **Upcoming** / Coming Soon movies (paginated)
- **Search** movies with debounced queries and Top Searches
- Profile selection (Who’s Watching)
- Home hero with Previews and Continue Watching rows
- Downloads & More screens (UI)
- Persistent bottom navigation (Home, Search, Coming Soon, Downloads, More)
- Responsive UI helpers (`.w`, `.h`, `.sp`, `.r`)
- Loading indicators
- Error handling with user-facing messages
- Retry support on failed API loads
- Clean Architecture (Presentation → Domain → Data)
- BLoC state management

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Language (sound null safety) |
| **flutter_bloc** | State management (BLoC) |
| **Dio** | HTTP client + interceptors |
| **Equatable** | Value equality for states/events |
| **get_it** | Service locator |
| **injectable** | Code-gen dependency injection |
| **cached_network_image** | Cached poster/backdrop loading |
| **GoRouter** | Declarative navigation |
| **stream_transform** | Debounced search events |
| **pretty_dio_logger** | Debug network logging |
| **TMDB API** | Movie data source |

> Models are parsed manually via `fromJson` factories (no `json_serializable` in this project). Local persistence (e.g. SharedPreferences) is not required for the current feature set.

## Architecture

```
lib/
├── features/
│   ├── home/           # Splash, home feed, main shell
│   ├── search/         # Search UI + SearchBloc
│   ├── coming_soon/    # Upcoming movies + pagination
│   ├── download/       # Downloads UI
│   ├── more/           # More / profile menu UI
│   └── username/       # Profile picker
├── shared/
│   ├── config/         # API constants
│   ├── dependencyInjection/
│   ├── domain/         # Repository contracts
│   ├── models/         # MovieModel, Result, Failure
│   ├── network/        # DioClient, interceptors, endpoints
│   ├── routes/         # GoRouter setup
│   ├── utils/          # Responsive helpers
│   └── widgets/        # Shared UI (bottom nav, network image)
├── app.dart
└── main.dart
```

**Layers**

1. **Presentation** — Screens + BLoC (events / states)
2. **Domain** — Repository interfaces
3. **Data** — `MovieApiService` (Dio) + `MovieRepositoryImpl`

## Getting Started

### Prerequisites

- Flutter SDK (stable)
- A free [TMDB API key](https://www.themoviedb.org/settings/api) (v3 auth key)

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/movieapp.git
cd movieapp
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure the API key (`.env`)

Copy the example env file and add your key:

```bash
cp .env.example .env
```

Edit `.env`:

```env
TMDB_API_KEY=your_tmdb_v3_api_key_here
```

> `.env` is gitignored. Never commit your real API key. Use `.env.example` as the template for others.

### 4. Run the app

```bash
flutter run --dart-define-from-file=.env
```

Alternative (without a file):

```bash
flutter run --dart-define=TMDB_API_KEY=your_tmdb_v3_api_key_here
```

### 5. Build a release APK

```bash
flutter build apk --release --dart-define-from-file=.env
```

APK output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Code Generation

Regenerate injectable DI after adding/moving `@injectable` classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Project Structure (features)

| Feature | Description |
|---|---|
| **Home** | Hero banner, Previews, Continue Watching, Popular, Trending, Top Rated |
| **Search** | Top Searches (trending) + live search |
| **Coming Soon** | Notifications header + upcoming movie cards |
| **Downloads** | Smart Downloads intro UI |
| **More** | Profiles, share card, settings list |

## API

Base URL: `https://api.themoviedb.org/3`

Used endpoints include:

- `/trending/all/week`
- `/movie/popular`
- `/movie/top_rated`
- `/movie/now_playing`
- `/movie/upcoming`
- `/search/movie`

Images are loaded from `https://image.tmdb.org/t/p/`.

## Screenshots

<!-- Add screenshots under assets/ or docs/ and link them here -->

| Home | Search | Coming Soon |
|---|---|---|
| *(add image)* | *(add image)* | *(add image)* |

## Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is for educational / portfolio use. Movie data and images belong to [TMDB](https://www.themoviedb.org/) and their respective owners. This product uses the TMDB API but is not endorsed or certified by TMDB.

## Acknowledgements

- [The Movie Database (TMDB)](https://www.themoviedb.org/)
- [Flutter](https://flutter.dev/)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [Dio](https://pub.dev/packages/dio)
