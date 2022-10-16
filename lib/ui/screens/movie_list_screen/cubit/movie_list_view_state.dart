import 'package:the_movie_db/domain/local_entity/movie_list/movie_list_data.dart';

class MovieListViewState {
  final List<MovieListData> movies;
  final String localeTag;

  const MovieListViewState({
    required this.movies,
    required this.localeTag,
  });

  MovieListViewState copyWith({
    List<MovieListData>? movies,
    String? localeTag,
    String? searchQuery,
  }) {
    return MovieListViewState(
      movies: movies ?? this.movies,
      localeTag: localeTag ?? this.localeTag,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListViewState &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          localeTag == other.localeTag;

  @override
  int get hashCode => movies.hashCode ^ localeTag.hashCode;
}
