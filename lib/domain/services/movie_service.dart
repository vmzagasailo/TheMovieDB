import 'package:the_movie_db/configuration/configuration.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/entity/movie/movie_response/movies_response.dart';
import 'package:the_movie_db/domain/local_entity/movie_details/movie_details_local.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';

class MovieService implements MovieDetailsModelMovieProvider {
  final MovieApiClient movieApiClient;
  final SessionDataProvider sessionDataProvider;
  final AccountApiClient accountApiClient;

  const MovieService({
    required this.movieApiClient,
    required this.sessionDataProvider,
    required this.accountApiClient,
  });

  Future<MoviesResponse> loadPopularMovie(int page, String locale) async =>
      movieApiClient.getPopularMovies(
          page: page, locale: locale, apiKey: Configuration.apiKey);

  Future<MoviesResponse> searchMovie(
          int page, String locale, String query) async =>
      movieApiClient.searchMovie(
          page: page,
          locale: locale,
          query: query,
          apiKey: Configuration.apiKey);

  @override
  Future<MovieDetailsLocal> loadMovieDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDetails = await movieApiClient.getMoviesDetails(movieId, locale);
    final sessionId = await sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await movieApiClient.isFavorite(movieId, sessionId);
    }

    return MovieDetailsLocal(
        movieDetails: movieDetails, isFavorite: isFavorite);
  }

  @override
  Future<void> updateFavorite({
    required bool isFavorite,
    required int movieId,
  }) async {
    final sessionId = await sessionDataProvider.getSessionId();
    final accountId = await sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}
