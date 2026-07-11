/// Central API / image configuration.
///
/// Load the TMDB key from a local `.env` file (see `.env.example`):
/// ```bash
/// flutter run --dart-define-from-file=.env
/// ```
///
/// Or pass it directly:
/// ```bash
/// flutter run --dart-define=TMDB_API_KEY=YOUR_API_KEY
/// ```
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/w780';

  /// Injected at compile time from `.env` or `--dart-define`.
  static const String apiKey = String.fromEnvironment('TMDB_API_KEY');

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  /// Builds a poster image URL from a TMDB [path].
  static String posterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$imageBaseUrl$path';
  }

  /// Builds a backdrop image URL from a TMDB [path].
  static String backdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$backdropBaseUrl$path';
  }
}
