import 'dart:convert';
import 'dart:io';

import 'package:the_movie_db/configuration/configuration.dart';
import 'package:the_movie_db/domain/api_client/network_client.dart';
import 'package:the_movie_db/domain/entity/movie/movie_response/movies_response.dart';
import 'package:the_movie_db/domain/entity/movie/movie_details/movie_details.dart';

abstract class MovieApiClient {
  Future<MoviesResponse> getPopularMovies({
    required int page,
    required String locale,
    required String apiKey,
  });

  Future<MoviesResponse> searchMovie({
    required int page,
    required String locale,
    required String query,
    required String apiKey,
  });

  Future<MovieDetails> getMoviesDetails(
    int movieId,
    String locale,
  );

  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  );
}

class MovieApiClientDefault implements MovieApiClient {
  final NetworkClient netWorkClient;

  const MovieApiClientDefault(this.netWorkClient);

  @override
  Future<MoviesResponse> getPopularMovies({
    required int page,
    required String locale,
    required String apiKey,
  }) async {
    MoviesResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final movies = MoviesResponse.fromJson(jsonMap);

      return movies;
    }

    final result = netWorkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': '$page',
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<MoviesResponse> searchMovie({
    required int page,
    required String locale,
    required String query,
    required String apiKey,
  }) async {
    MoviesResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final movies = MoviesResponse.fromJson(jsonMap);

      return movies;
    }

    final result = netWorkClient.get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': '$page',
        'language': locale,
        'query': query,
        'include_adult': true.toString()
      },
    );
    return result;
  }

  @override
  Future<MovieDetails> getMoviesDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);

      return response;
    }

    final result = netWorkClient.get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = netWorkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}