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
