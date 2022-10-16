import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/blocs/movie_list/movie_list_bloc.dart';
import 'package:the_movie_db/domain/entity/movie/movie.dart';
import 'package:the_movie_db/domain/local_entity/movie_list/movie_list_data.dart';
import 'package:the_movie_db/ui/screens/movie_list_screen/cubit/movie_list_view_state.dart';

class MovieListViewCubit extends Cubit<MovieListViewState> {
  final MovieListBloc movieListBloc;
  late final StreamSubscription<MovieListState> movieListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  MovieListViewCubit({
    required this.movieListBloc,
  }) : super(
          const MovieListViewState(
            movies: <MovieListData>[],
            localeTag: "",
          ),
        ) {
    Future.microtask(
      () {
        _onState(movieListBloc.state);
        movieListBlocSubscription = movieListBloc.stream.listen(_onState);
      },
    );
  }

  void _onState(MovieListState state) {
    final movies = state.movies.map(_makeRowData).toList();
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    movieListBloc.add(MovieListResetEvent());
    movieListBloc.add(MovieListLoadNextPageEvent(localeTag));
  }

  void showedMovieAtIndex(int index) {
    if (index < state.movies.length - 1) return;
    movieListBloc.add(MovieListLoadNextPageEvent(state.localeTag));
  }

  void searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      movieListBloc.add(MovieListSearchEvent(text));
      movieListBloc.add(MovieListLoadNextPageEvent(state.localeTag));
    });
  }

  @override
  Future<void> close() {
    movieListBlocSubscription.cancel();
    return super.close();
  }

  MovieListData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListData(
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title,
      releaseDate: releaseDateTitle,
      overview: movie.overview,
    );
  }
}
