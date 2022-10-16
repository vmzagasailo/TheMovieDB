import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:the_movie_db/configuration/configuration.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/entity/movie/movie.dart';
import 'package:the_movie_db/domain/entity/movie/movie_response/movies_response.dart';

part 'movie_list_state.dart';
part 'movie_list_event.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieApiClient movieApiClient;

  MovieListBloc(
    MovieListState initialState, {
    required this.movieApiClient,
  }) : super(initialState) {
    on<MovieListEvent>((event, emit) async {
      if (event is MovieListLoadNextPageEvent) {
        await onMovieListEventLoadNextPage(event, emit);
      } else if (event is MovieListResetEvent) {
        await onMovieListEventLoadReset(event, emit);
      } else if (event is MovieListSearchEvent) {
        await onMovieListEventLoadSearchMovie(event, emit);
      }
    }, transformer: sequential());
  }

  Future<void> onMovieListEventLoadNextPage(
    MovieListLoadNextPageEvent event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(
        state.searchMovieContainer,
        (nextPage) async {
          final result = await movieApiClient.searchMovie(
            page: nextPage,
            locale: event.locale,
            query: state.searchQuery,
            apiKey: Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(searchMovieContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(
        state.popularMovieContainer,
        (nextPage) async {
          final result = await movieApiClient.getPopularMovies(
            page: nextPage,
            locale: event.locale,
            apiKey: Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularMovieContainer: container);
        emit(newState);
      }
    }
  }

  Future<MovieListContainer?> _loadNextPage(
    MovieListContainer container,
    Future<MoviesResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final movies = List<Movie>.from(container.movies)..addAll(result.movies);
    final newContainer = container.copyWith(
      movies: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onMovieListEventLoadReset(
    MovieListResetEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const MovieListState.initial());
  }

  Future<void> onMovieListEventLoadSearchMovie(
    MovieListSearchEvent event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.searchQuery == event.query) return;
    final newState = state.copyWith(
      searchQuery: event.query,
      searchMovieContainer: const MovieListContainer.initial(),
    );
    emit(newState);
  }
}
